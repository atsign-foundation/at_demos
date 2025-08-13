class SendHrO2Receiver {
  String receiverAtsign;
  bool sendHR;
  bool sendO2;
  String receiverShortname = "";

  SendHrO2Receiver(
      {required this.receiverAtsign,
      required this.sendHR,
      required this.sendO2,
      required this.receiverShortname});

  SendHrO2Receiver.fromJson(Map<String, dynamic> json)
      : receiverAtsign = json['receiverAtsign'],
        sendHR = json['sendHR'],
        sendO2 = json['sendO2'],
        receiverShortname = json['receiverShortname'];

  Map<String, dynamic> toJson() => {
        'receiverAtsign': receiverAtsign,
        'sendHR': sendHR,
        'sendO2': sendO2,
        'receiverShortname': receiverShortname,
      };
}
