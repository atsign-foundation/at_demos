class SendHrO2Receiver {
  String sendToAtsign;
  String sendHR;
  String sendO2;
  String sendToShortname = "";


  SendHrO2Receiver({required this.sendToAtsign, required this.sendHR, required this.sendO2, required this.sendToShortname});

  SendHrO2Receiver.fromJson(Map<String, dynamic> json)
      : sendToAtsign = json['sendToAtsign'],
        sendHR = json['sendHR'],
        sendO2 = json['sendO2'],
        sendToShortname = json['sendToShortname'];

  Map<String, dynamic> toJson() => {
        'sendToAtsign': sendToAtsign,
        'sendHR': sendHR,
        'sendO2': sendO2,
        'sendToShortname': sendToShortname,
      };
}
