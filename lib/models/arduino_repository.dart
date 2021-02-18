import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iot_logger/models/message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'StateMessage.dart';
import 'dataMessage.dart';

class ArduinoRepository {
  var directory;
  String currentFile = '';
  int currentFileSize = 0;
  final int messageDataIndex =
      5; //Number of bytes before the data part of a message
  final int sensorType = 0; //App is sensor 0
  Uint8List messageData = Uint8List(256);
  Uint8List messageBuffer = Uint8List(0);
  MessageState currentState = MessageState.START;
  MessageType messageId = MessageType.CONNECT;
  int payloadSize = 0;
  int sequenceNumber = 0;
  int receivedSensorType = 0;
  int currentPayloadByte = 0;
  int missedBytes = 0;
  RestartableTimer countdownTimer;
  bool arduinoisConnected = true;
  RawDatagramSocket _socket;
  Timer heartBeatTimer;
  int messageCounter = 0;
  bool newMessageReceived = false;
  BytesBuilder messageFile;
  StreamController<StateMessage> controller;
  Stream messageStream;
  StreamController<bool> heartBeatController;
  Stream heartBeatStream;
  String wifiIP, wifiName;
  StreamSubscription _subscription;
  final Connectivity _connectivity = Connectivity();

  ArduinoRepository() {
    initialiseWifiConnection();
    setLocalDirectory();
    controller = StreamController<StateMessage>.broadcast();
    messageStream = controller.stream;
    heartBeatController = StreamController<bool>.broadcast();
    heartBeatStream = heartBeatController.stream;
  }

  initialiseWifiConnection() async {
    print("Initialising Wifi Connection...");
    if (Platform.isAndroid) {
      WiFiForIoTPlugin.forceWifiUsage(true);
    } else {
      // iOS needs an initial connection
      try {
        wifiName = await WifiInfo().getWifiName();
        wifiIP = await WifiInfo().getWifiIP();
        // Wifi Connected
        if (wifiIP != null && wifiName != null) {
          print('Wifi Connected: $wifiName $wifiIP');
          initialiseArduinoConnection(wifiIP);
        } else {
          // No Wifi Found
          print('No Wifi Detected');
        }
      } catch (e) {
        //messageSubscription.cancel();
        print("No Connections Found");
        print(e.toString());
      }
    }

    // Listen and adjust to changes in the network
    _subscription = _connectivity.onConnectivityChanged.listen(
      (status) async {
        print("Connection Detected");
        try {
          wifiName = await WifiInfo().getWifiName();
          wifiIP = await WifiInfo().getWifiIP();

          // If Wifi is connected
          // if (wifiIP != null && wifiName != null) {
          print('Wifi Connected: $wifiName @ $wifiIP');

          initialiseArduinoConnection(wifiIP);
          // } else {
          //No Wifi Found
          // print('No Wifi Detected');
          // }
        } catch (e) {
          //messageSubscription.cancel();
          print("No Connections Found");
          print(e.toString());
        }
      },
    );
  }

  initialiseArduinoConnection(String wifiIP) {
    print("Initialising Arduino Connection...");
    // Create UDP Socket to Arduino
    try {
      RawDatagramSocket.bind(InternetAddress(wifiIP), 4444)
          .then((RawDatagramSocket socket) {
        this._socket = socket;
        print('Creating UDP Server @ ${socket.address.address}:${socket.port}');

        // Send Heart Beat
        heartBeatTimer = new Timer.periodic(Duration(seconds: 1), (Timer t) {
          if (arduinoisConnected) {
            print("heart beat sent");
            messageBuffer = Uint8List.fromList(
                [0xFE, 1, messageCounter, 0, 0, 1]); // Heart Beat Message
            sendMessageBuffer(messageBuffer);
          }
        });

        // Start connection timer
        countdownTimer = new RestartableTimer(Duration(seconds: 3), () {
          heartBeatController.add(false);
          print("Arduino TimedOut");
        });

        //Listen for messages
        _socket.listen((event) {
          Datagram d = socket.receive();
          if (d == null) return;
          readMessage(d.data);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  stopHeartBeat() {
    print("arduino disconnected");
    arduinoisConnected = false;
    heartBeatTimer.cancel();
  }

  readMessage(Uint8List data) {
    for (int i = 0; i < data.length; i++) {
      msgParseByte(data[i]);
    }
  }

  void msgParseByte(int messageByte) {
    switch (currentState) {
      case MessageState.START:
        if (messageByte == 0xFE) {
          currentState = MessageState.PAYLOAD;
        } else {
          print("Waiting byte recieved: + $messageByte");
        }
        break;
      case MessageState.PAYLOAD:
        payloadSize = messageByte;
        currentState = MessageState.SEQUENCE;
        break;
      case MessageState.SEQUENCE:
        if ((sequenceNumber) != messageByte) {
          print("Bad sequence number: $sequenceNumber vs $messageByte");
          //missedBytes = missedBytes + ((sequenceNumber - messageByte).abs() * 255);
        }
        sequenceNumber = messageByte + 1;
        if (sequenceNumber == 256) {
          sequenceNumber = 0;
        }
        currentState = MessageState.SENSOR_TYPE;
        break;
      case MessageState.SENSOR_TYPE:
        receivedSensorType = messageByte;
        currentState = MessageState.MESSAGE_ID;
        break;
      case MessageState.MESSAGE_ID:
        messageId = messageMap[messageByte];
        currentState = MessageState.DATA;
        break;
      case MessageState.DATA:
        parsePayloadByte(messageByte);
        break;
      default:
        print("Bad message state");
        break;
    }
  }

  void parsePayloadByte(int payloadByte) {
    messageData[currentPayloadByte] = payloadByte;
    currentPayloadByte++;
    if (currentPayloadByte >= payloadSize) {
      // All data bytes read so parse it
      parsePayload();
      currentPayloadByte = 0;
      currentState = MessageState.START;
    }
  }

  // Incoming Messages
  parsePayload() {
    //Do something with the data payload
    messageData[currentPayloadByte] = 0;
    switch (messageId) {
      case MessageType.HEART_BEAT:
        heartBeatController.add(true);
        arduinoisConnected = true;
        countdownTimer.reset();
        break;
      case MessageType.CONNECT:
        newMessageReceived = true;
        print('CONNECT ' + String.fromCharCodes(messageData));
        break;
      case MessageType.SEND_LOG_FILE_SIZE:
        newMessageReceived = true;
        ByteData logFileSize =
            ByteData.sublistView(messageData, 0, payloadSize);
        currentFileSize = logFileSize.getInt32(0, Endian.little);
        print('Log File Size Received = ' + currentFileSize.toString());
        break;
      case MessageType.SEND_LOG_FILE_NAME:
        newMessageReceived = true;
        print('Log File Name Received: ' +
            String.fromCharCodes(
                messageData.sublist(0, payloadSize))); //messageData
        break;
      case MessageType.SEND_LOG_FILE_CHUNK:
        messageFile.add(messageData.sublist(0, payloadSize));

        print("Current Log File Size = " +
            messageFile.length.toString() +
            " totalSize = " +
            currentFileSize.toString());

        // When file is downloaded
        if (messageFile.length / (currentFileSize - missedBytes) == 1.0) {
          messageFile = BytesBuilder();
          missedBytes = 0;
          currentFileSize = 0;
          // Write log file chunk to file, if there is no file this will create one
          File('${directory.path}/$currentFile')
              .writeAsStringSync(messageFile.toString());
          controller.add(StateMessage(
              ((messageFile.length / currentFileSize) * 100).roundToDouble()));
          print("File Downloaded");
        } else {
          controller.add(StateMessage(
              ((messageFile.length / currentFileSize) * 100).roundToDouble()));
        }
        break;
      case MessageType.SEND_SD_CARD_INFO:
        newMessageReceived = true;
        ByteData sdCardInfo = ByteData.sublistView(messageData, 0, payloadSize);
        print(messageData.sublist(0, payloadSize));
        print('Card Used Space: ' +
            sdCardInfo.getInt16(0, Endian.little).toString() +
            ' Card Remaining Space: ' +
            sdCardInfo.getInt16(2, Endian.little).toString());
        break;
      case MessageType.SEND_LOGGING_PERIOD:
        newMessageReceived = true;
        ByteData loggingPeriod =
            ByteData.sublistView(messageData, 0, payloadSize);
        print('Logging Period Received: ' +
            loggingPeriod.getInt32(0, Endian.little).toString());
        break;
      case MessageType.SEND_RTC_TIME:
        newMessageReceived = true;
        ByteData rtcTime = ByteData.sublistView(messageData, 0, payloadSize);
        print('Received RTC Time = ' +
            rtcTime.getInt32(0, Endian.little).toString());
        break;
      case MessageType.SEND_CURRENT_MEASUREMENTS:
        print('Current Measurements Message Received: ' +
            String.fromCharCodes(
                messageData.sublist(0, payloadSize))); //messageData
        break;
      case MessageType.SEND_BATTERY_INFO:
        newMessageReceived = true;
        ByteData batteryInfo =
            ByteData.sublistView(messageData, 0, payloadSize);
        print('Battery Voltage: ' +
            batteryInfo.getFloat32(0, Endian.little).toString() +
            ' Battery ADC Reading: ' +
            batteryInfo.getInt32(4, Endian.little).toString());
        break;
      case MessageType.ERROR_MSG:
        newMessageReceived = true;
        print('Error Message Received: ' +
            String.fromCharCodes(
                messageData.sublist(0, payloadSize))); //messageData
        break;
      default:
        print(
            'Default Message Type (means this message type has not been mapped');
    }
  }

  // Outgoing Messages
  getLoggingPeriod() {
    int payloadSize = 1;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_LOGGING_PERIOD];
    messageBuffer[5] = 1; // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT LOGGING PERIOD REQUEST');
  }

  getBatteryInfo() {
    int payloadSize = 1;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_BATTERY_INFO];
    messageBuffer[5] = 1; // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT BATTERY INFO REQUEST');
  }

  getSDCardInfo() {
    int payloadSize = 1;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_SD_CARD_INFO];
    messageBuffer[5] = 1; // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT SD CARD INFO REQUEST');
  }

  getRTCTime() {
    int payloadSize = 1;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_RTC_TIME];
    messageBuffer[5] = 1; // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT RTC TIME REQUEST');
  }

  setRTCTime() {
    int time = (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    int payloadSize = 4;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.SET_RTC_TIME];
    messageBuffer
      ..buffer.asByteData().setInt32(5, time, Endian.little); // Payload
    //print(messageBuffer.sublist(0, payloadSize + messageDataIndex).toString());
    sendMessageBuffer(messageBuffer);
    print('SENT CURRENT MEASUREMENT REQUEST');
  }

  setLoggingPeriod(int loggingPeriod) {
    int payloadSize = 4;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.SET_LOGGING_PERIOD];
    messageBuffer
      ..buffer
          .asByteData()
          .setInt32(5, loggingPeriod, Endian.little); // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT CURRENT MEASUREMENT REQUEST');
  }

  getLogsList() {
    int payloadSize = 1;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_LOGS_LIST];
    messageBuffer[5] = 1; // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT GET LOG LIST REQUEST');
  }

  getLogFile(String fileName) {
    missedBytes = 0;
    messageFile = new BytesBuilder();
    //clear the file if it is already present
    if (File('${directory.path}/$fileName').existsSync()) {
      print("Deleted Existing ${directory.path}/$fileName' file");
      File('${directory.path}/$fileName').delete();
    }

    currentFile = fileName;
    List<int> bytes = fileName.codeUnits;
    int payloadSize = bytes.length;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_LOG_FILE];
    for (int i = 0; i < payloadSize; i++) {
      messageBuffer[i + messageDataIndex] =
          bytes[i]; // insert fileName String as payload
    }

    sendMessageBuffer(messageBuffer);
    print('SENT LOG FILE REQUEST: $fileName');
  }

  getLogFileSize(String fileName) {
    List<int> bytes = fileName.codeUnits;
    int payloadSize = bytes.length;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_LOG_FILE_SIZE];
    for (int i = 0; i < payloadSize; i++) {
      messageBuffer[i + messageDataIndex] =
          bytes[i]; // insert fileName as payload
    }

    sendMessageBuffer(messageBuffer);
    print('SENT LOG FILE SIZE REQUEST: $fileName');
  }

  getCurrentMeasurements(int decimalPlaces) {
    int payloadSize = 4;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_CURRENT_MEASURMENTS];
    messageBuffer
      ..buffer
          .asByteData()
          .setInt32(5, decimalPlaces, Endian.little); // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT CURRENT MEASUREMENT REQUEST');
  }

  setWifiSSID(String ssid) {
    List<int> bytes = ssid.codeUnits;
    int payloadSize = bytes.length;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.SET_WIFI_SSID];
    for (int i = 0; i < payloadSize; i++) {
      messageBuffer[i + messageDataIndex] =
          bytes[i]; // insert fileName as payload
    }

    sendMessageBuffer(messageBuffer);
    print('SENT SET WIFI SSID REQUEST');
  }

  setWifiPassword(String password) {
    List<int> bytes = password.codeUnits;
    int payloadSize = bytes.length;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.SET_WIFI_PASSWORD];
    for (int i = 0; i < payloadSize; i++) {
      messageBuffer[i + messageDataIndex] = bytes[i]; // insert ssid as payload
    }

    sendMessageBuffer(messageBuffer);
    print('SENT SET WIFI PASSWORD REQUEST');
  }

  deleteLogFile(String fileName) {
    List<int> bytes = fileName.codeUnits;
    int payloadSize = bytes.length;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.DELETE_LOG_FILE];
    for (int i = 0; i < payloadSize; i++) {
      messageBuffer[i + messageDataIndex] =
          bytes[i]; // insert fileName as payload
    }

    sendMessageBuffer(messageBuffer);
    print('SENT DELETE FILE REQUEST');
  }

  sendMessageBuffer(Uint8List messageBuffer) {
    try {
      _socket.send(messageBuffer, InternetAddress("10.0.0.1"), 2506);
      messageCounter++;
    } catch (e) {
      print(e);
    }
  }

  Future<void> setLocalDirectory() async {
    directory = await getApplicationDocumentsDirectory();
  }
}

Map messageIndexMap = {
  MessageType.HEART_BEAT: 0,
  MessageType.CONNECT: 1,
  MessageType.GET_CURRENT_MEASURMENTS: 2,
  MessageType.GET_LOG_FILE: 3,
  MessageType.SEND_LOG_FILE_SIZE: 4,
  MessageType.SEND_LOG_FILE_CHUNK: 5,
  MessageType.GET_LOGGING_PERIOD: 6,
  MessageType.SET_LOGGING_PERIOD: 7,
  MessageType.SEND_SD_CARD_INFO: 8,
  MessageType.GET_LOGS_LIST: 9,
  MessageType.SEND_LOG_FILE_NAME: 10,
  MessageType.SEND_LOGGING_PERIOD: 11,
  MessageType.GET_RTC_TIME: 12,
  MessageType.SET_RTC_TIME: 13,
  MessageType.SEND_RTC_TIME: 14,
  MessageType.SEND_CURRENT_MEASUREMENTS: 15,
  MessageType.DELETE_LOG_FILE: 16,
  MessageType.GET_SD_CARD_INFO: 17,
  MessageType.GET_BATTERY_INFO: 18,
  MessageType.SEND_BATTERY_INFO: 19,
  MessageType.GET_LOG_FILE_SIZE: 20,
  MessageType.SET_WIFI_SSID: 21,
  MessageType.SET_WIFI_PASSWORD: 22,
  MessageType.ERROR_MSG: 200
};

//Defines the states of the state machine to parse a full message
enum MessageState {
  WAITING,
  START,
  PAYLOAD,
  SEQUENCE,
  SENSOR_TYPE,
  MESSAGE_ID,
  DATA
}