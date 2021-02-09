import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

class Message {
  int startPacket;
  int payloadLength;
  int packetSequence;
  SensorType sensorType;
  MessageType messageType;
  Uint8List payload;
  Message(Uint8List data) {
    // print(this.startPacket.bitLength); // Uint8List ensure's all int variables are saved as 8 bits of data
    this.startPacket = data[0];
    this.payloadLength = data[1];
    this.packetSequence = data[2];
    this.sensorType = sensorMap[data[3]];
    this.messageType = messageMap[data[4]];
    this.payload = data.sublist(5, (payloadLength + 5));
  }
}

enum SensorType { APP, TURBIDITY, PH }

Map sensorMap = {
  0: SensorType.APP,
  1: SensorType.TURBIDITY,
  2: SensorType.PH,
};

enum MessageType {
  HEART_BEAT,
  CONNECT,
  GET_CURRENT_MEASURMENTS,
  GET_LOG_FILE,
  SEND_LOG_FILE_SIZE,
  SEND_LOG_FILE_CHUNK,
  GET_LOGGING_PERIOD,
  SET_LOGGING_PERIOD,
  SEND_SD_CARD_INFO,
  GET_LOGS_LIST,
  SEND_LOG_FILE_NAME,
  SEND_LOGGING_PERIOD,
  GET_RTC_TIME,
  SET_RTC_TIME,
  SEND_RTC_TIME,
  SEND_CURRENT_MEASUREMENTS,
  DELETE_LOG_FILE,
  GET_SD_CARD_INFO,
  GET_BATTERY_INFO,
  SEND_BATTERY_INFO,
  GET_LOG_FILE_SIZE,
  ERROR_MSG,
}

Map messageMap = {
  0: MessageType.HEART_BEAT,
  1: MessageType.CONNECT,
  2: MessageType.GET_CURRENT_MEASURMENTS,
  3: MessageType.GET_LOG_FILE,
  4: MessageType.SEND_LOG_FILE_SIZE,
  5: MessageType.SEND_LOG_FILE_CHUNK,
  6: MessageType.GET_LOGGING_PERIOD,
  7: MessageType.SET_LOGGING_PERIOD,
  8: MessageType.SEND_SD_CARD_INFO,
  9: MessageType.GET_LOGS_LIST,
  10: MessageType.SEND_LOG_FILE_NAME,
  11: MessageType.SEND_LOGGING_PERIOD,
  12: MessageType.GET_RTC_TIME,
  13: MessageType.SET_RTC_TIME,
  14: MessageType.SEND_RTC_TIME,
  15: MessageType.SEND_CURRENT_MEASUREMENTS,
  16: MessageType.DELETE_LOG_FILE,
  17: MessageType.GET_SD_CARD_INFO,
  18: MessageType.GET_BATTERY_INFO,
  19: MessageType.SEND_BATTERY_INFO,
  20: MessageType.GET_LOG_FILE_SIZE,
  200: MessageType.ERROR_MSG
};
