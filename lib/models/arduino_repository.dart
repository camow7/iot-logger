import 'dart:typed_data';
import 'package:iot_logger/models/message.dart';

class ArduinoRepository {
  fetchMessage(String fileName) {}

  readMessage(Uint8List data) {
    Message message = new Message(data);
    // switch(message.messageType){
    //   case :
    // }
  }
}
