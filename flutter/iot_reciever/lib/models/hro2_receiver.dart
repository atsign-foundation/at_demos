class HrO2Receiver {
  String deviceAtsign;
  String sendToAtsign;
  String sendToShortname;
  String receiverUuid;
  bool sendHR;
  bool sendO2;

  HrO2Receiver(
      {required this.deviceAtsign,
      required this.sendToAtsign,
      required this.sendHR,
      required this.sendO2,
      this.sendToShortname = "",
      required this.receiverUuid});
}
