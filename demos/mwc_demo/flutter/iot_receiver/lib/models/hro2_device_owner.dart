import 'package:iot_receiver/models/hro2_device.dart';

class HrO2DeviceOwner {
  HrO2Device hrO2Device;
  String deviceOwnerAtsign;

  HrO2DeviceOwner({
    required this.hrO2Device,
    required this.deviceOwnerAtsign,
  });

  HrO2DeviceOwner.fromJson(Map<String, dynamic> json)
      : hrO2Device = HrO2Device.fromJson(json['hrO2Device']),
        deviceOwnerAtsign = json['deviceOwnerAtsign'];

  Map<String, dynamic> toJson() => {
        'hrO2Device': hrO2Device.toJson(),
        'deviceOwnerAtsign': deviceOwnerAtsign,
      };
}
