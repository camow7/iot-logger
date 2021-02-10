import 'dart:typed_data';
import 'package:iot_logger/models/message.dart';

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

class ArduinoRepository {
  List<int> messageData = List(256);
  MessageState currentState = MessageState.START;
  MessageType messageId = MessageType.CONNECT;
  int payloadSize = 0;
  int sequenceNumber = 0;
  int receivedSensorType = 0;
  int currentPayloadByte = 0;

  fetchMessage(String fileName) {}

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

  void parsePayload() {
    //Do something with the data payload
    messageData[currentPayloadByte] =
        0; //does this indicate the end of the message
    switch (messageId) {
      case MessageType.HEART_BEAT:
        print('HEART_BEAT Received');
        //resetConnectionTimeout();
        break;
      case MessageType.CONNECT:
        print('CONNECT String ' + String.fromCharCodes(messageData));
        break;
      case MessageType.SEND_LOG_FILE_SIZE:
        // TODO: Handle this case.
        // save log file size
        break;
      case MessageType.SEND_LOG_FILE_CHUNK:
        // TODO: Handle this case.
        break;
      case MessageType.SEND_SD_CARD_INFO:
        // TODO: Handle this case.
        break;
      case MessageType.SEND_LOGGING_PERIOD:
        // TODO: Handle this case.
        break;
      case MessageType.SEND_RTC_TIME:
        // TODO: Handle this case.
        break;
      case MessageType.SEND_CURRENT_MEASUREMENTS:
        // TODO: Handle this case.
        //save current measurements
        break;
      case MessageType.SEND_BATTERY_INFO:
        // TODO: Handle this case.
        break;
      case MessageType.ERROR_MSG:
        print('Error Message Received: ' +
            String.fromCharCodes(
                messageData.sublist(0, payloadSize))); //messageData
        break;
      default:
        print(
            'Default Message Type Receiced (might mean its not mapped properly');
    }
  }
}
