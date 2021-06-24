class HeartBeatMessage {
  bool isConnected;
  bool networkFound;
  int sensorID;

  HeartBeatMessage(bool isConnected, int sensorID, bool networkFound) {
    this.isConnected = isConnected;
    this.sensorID = sensorID;
    this.networkFound = networkFound;
  }

  // HeartBeatMessage(bool isConnected, int sensorID) {
  //   this.isConnected = isConnected;
  //   this.sensorID = sensorID;
  
  // }

}

Map sensorMap = {
  -1: "Sensor",
  0: "App",
  1: "TURBIDITY",
  2: "PH",
};
