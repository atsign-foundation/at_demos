class HrO2Receiver {
  String sendToAtsign;
  String sendToShortname;
  bool sendHR;
  bool sendO2;

  HrO2Receiver({required this.sendToAtsign, required this.sendHR, required this.sendO2, this.sendToShortname= ""});
}
