import 'dart:core';
import 'dart:typed_data';

class Message {
  int startPacket;
  int payloadLength;
  int packetSequence;
  int messageID;
  int sensorType;
  String messageType;
  Uint8List payload;
  Message(Uint8List data) {
    this.startPacket = data[0];
    this.payloadLength = data[1];
    this.packetSequence = data[2];
    this.sensorType = data[3];
    this.messageID = data[4];
    this.payload = data.sublist(5, (payloadLength + 5));
  }
}
