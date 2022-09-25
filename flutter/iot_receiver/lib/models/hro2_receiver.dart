import 'package:iot_receiver/models/hro2_device.dart';

class HrO2Receiver {
  HrO2Device hrO2Device;
  String sendToAtsign;
  String sendToShortname;
  bool sendHR;
  bool sendO2;

  HrO2Receiver({
    required this.hrO2Device,
    required this.sendToAtsign,
    required this.sendHR,
    required this.sendO2,
    this.sendToShortname = "",
  });

  HrO2Receiver.fromJson(Map<String, dynamic> json)
      : hrO2Device = HrO2Device.fromJson(json['hrO2Device']),
        sendToAtsign = json['sendToAtsign'],
        sendHR = json['sendHR'],
        sendO2 = json['sendO2'],
        sendToShortname = json['sendToShortname'];

  Map<String, dynamic> toJson() => {
        'hrO2Device': hrO2Device.toJson(),
        'sendToAtsign': sendToAtsign,
        'sendHR': sendHR,
        'sendO2': sendO2,
        'sendToShortname': sendToShortname,
      };
}

class HrO2ReceiverList {
  late List<HrO2Receiver> hrO2ReceiverList;

  HrO2ReceiverList({
    required this.hrO2ReceiverList,
  });

  List<Map<String, dynamic>>? toJson() {
    List<Map<String, dynamic>>? devices =
        hrO2ReceiverList.map((i) => i.toJson()).toList();
    return devices;
  }

  factory HrO2ReceiverList.fromJson(dynamic json) {
    List<HrO2Receiver> devices = json
        .map((hrO2ReceiverListJson) =>
            HrO2Receiver.fromJson(hrO2ReceiverListJson))
        .toList();
    return HrO2ReceiverList(hrO2ReceiverList: devices);
  }
}
