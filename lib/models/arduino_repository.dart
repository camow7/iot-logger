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
  MessageState currentState = MessageState.START;
  int messageId = 0;
  int payloadSize = 0;
  int sequenceNumber = 0;
  int receivedSensorType = 0;
  int currentPayloadByte = 0;

  fetchMessage(String fileName) {}

  readMessage(Uint8List data) {
    Message message = new Message(data);

    for (int i = 0; i < message.payloadLength; i++) {
      msgParseByte(message.payload[i]);
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
        messageId = messageByte;
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
    //   messageData[currentPayloadByte] = payloadByte;
    //   currentPayloadByte++;
    //   if (currentPayloadByte >= payloadSize) {
    //     // All data bytes read so parse it
    //     parsePayload();
    //     currentPayloadByte = 0;
    //     currentState = START;
    //   }
    // }
  }
}
