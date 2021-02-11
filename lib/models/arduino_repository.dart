import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:iot_logger/models/message.dart';

class ArduinoRepository {
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
  RestartableTimer countdownTimer;
  bool arduinoisConnected = false;
  RawDatagramSocket _socket;
  Timer hearBeatTimer;
  int messageCounter = 0;

  initialiseConnection(String _wifiIP) {
    // Create UDP Socket to Arduino
    try {
      RawDatagramSocket.bind(InternetAddress(_wifiIP), 4444)
          .then((RawDatagramSocket socket) {
        this._socket = socket;
        print('UDP Server: ${socket.address.address}:${socket.port}');

        // Send Heart Beat
        hearBeatTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
          messageBuffer = Uint8List.fromList(
              [0xFE, 1, messageCounter, 0, 0, 1]); // Heart Beat Message
          sendMessageBuffer(messageBuffer);
          // print("Sent Heart Beat");
        });

        // Start connection timer
        countdownTimer = new RestartableTimer(Duration(seconds: 3), () {
          print('Arduino has timedout');
          arduinoisConnected = false;
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
        }
        sequenceNumber = messageByte + 1;
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
    // print(String.fromCharCode(payloadByte));
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
  void parsePayload() {
    //Do something with the data payload
    messageData[currentPayloadByte] = 0;
    switch (messageId) {
      case MessageType.HEART_BEAT:
        print('HEART_BEAT Received');
        countdownTimer.reset();
        break;
      case MessageType.CONNECT:
        print('CONNECT ' + String.fromCharCodes(messageData));
        break;
      case MessageType.SEND_LOG_FILE_SIZE:
        break;
      case MessageType.SEND_LOG_FILE_NAME:
        print('Log File Name Received: ' +
            String.fromCharCodes(
                messageData.sublist(0, payloadSize))); //messageData
        break;
      case MessageType.SEND_LOG_FILE_CHUNK:
        // Receive A log file here
        print('Log File Chunck Received');
        print(messageData.sublist(0, payloadSize));
        break;
      case MessageType.SEND_SD_CARD_INFO:
        ByteData sdCardInfo = ByteData.sublistView(messageData, 0, payloadSize);
        print(messageData.sublist(0, payloadSize));
        print('Card Used Space: ' +
            sdCardInfo.getInt16(0, Endian.little).toString() +
            ' Card Remaining Space: ' +
            sdCardInfo.getInt16(2, Endian.little).toString());
        break;
      case MessageType.SEND_LOGGING_PERIOD:
        ByteData loggingPeriod =
            ByteData.sublistView(messageData, 0, payloadSize);
        print('Logging Period Received: ' +
            loggingPeriod.getInt32(0, Endian.little).toString());
        break;
      case MessageType.SEND_RTC_TIME:
        ByteData rtcTime = ByteData.sublistView(messageData, 0, payloadSize);
        print('Received RTC Time = ' +
            rtcTime.getInt32(0, Endian.little).toString());
        break;
      case MessageType.SEND_CURRENT_MEASUREMENTS:
        // TODO: Handle this case.
        //save current measurements
        break;
      case MessageType.SEND_BATTERY_INFO:
        ByteData batteryInfo =
            ByteData.sublistView(messageData, 0, payloadSize);
        print('Battery Voltage: ' +
            batteryInfo.getFloat32(0, Endian.little).toString() +
            ' Battery ADC Reading: ' +
            batteryInfo.getInt32(4, Endian.little).toString());
        break;
      case MessageType.ERROR_MSG:
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
  // Working
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

  // Not Finished
  getCurrentMeasurements() {
    int payloadSize = 1;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_CURRENT_MEASURMENTS];
    messageBuffer[5] = 1; // Payload
    sendMessageBuffer(messageBuffer);
    print('SENT CURRENT MEASUREMENT REQUEST');
  }

  getLogFile(String fileName) {
    List<int> bytes = utf8.encode(
        fileName); //ASK CAM WHAT TO TRANSFER THESE AS UTF8, UTF 16......

    // int payloadSize = fileName.length.bitLength;
    messageBuffer = new Uint8List(payloadSize + messageDataIndex);
    messageBuffer[0] = 0xFE;
    messageBuffer[1] = payloadSize;
    messageBuffer[2] = messageCounter;
    messageBuffer[3] = sensorType;
    messageBuffer[4] = messageIndexMap[MessageType.GET_LOG_FILE];
    messageBuffer[5] =
        1; // Payload//NEED TO SET MESSAGE PAYLOAD TO STRING CONVERTED TO BYTES
    sendMessageBuffer(messageBuffer);
    print('SENT CURRENT MEASUREMENT REQUEST');
  }

  getLogFileInfo() {}

  deleteLogFile() {}

  sendMessageBuffer(Uint8List messageBuffer) {
    try {
      _socket.send(messageBuffer, InternetAddress("10.0.0.1"), 2506);
      messageCounter++;
    } catch (e) {
      print(e);
    }
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
