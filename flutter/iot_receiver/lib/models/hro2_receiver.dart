import 'package:iot_receiver/models/hro2_device.dart';

class HrO2Receiver {
  HrO2Device hrO2Device;
  String receiverAtsign;
  String receiverShortname;
  bool sendHR;
  bool sendO2;

  HrO2Receiver({
    required this.hrO2Device,
    required this.receiverAtsign,
    required this.sendHR,
    required this.sendO2,
    this.receiverShortname = "",
  });

  HrO2Receiver.fromJson(Map<String, dynamic> json)
      : hrO2Device = HrO2Device.fromJson(json['hrO2Device']),
        receiverAtsign = json['receiverAtsign'],
        sendHR = json['sendHR'],
        sendO2 = json['sendO2'],
        receiverShortname = json['sendToShortname'];

  Map<String, dynamic> toJson() => {
        'hrO2Device': hrO2Device.toJson(),
        'receiverAtsign': receiverAtsign,
        'sendHR': sendHR,
        'sendO2': sendO2,
        'receiverShortname': receiverShortname,
      };
}
