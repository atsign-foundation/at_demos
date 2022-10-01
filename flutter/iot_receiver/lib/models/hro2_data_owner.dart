import 'package:iot_receiver/models/hro2_device.dart';

class HrO2DataOwner {
  HrO2Device hrO2Device;
  String dataOwnerAtsign;

  HrO2DataOwner({
    required this.hrO2Device,
    required this.dataOwnerAtsign,
  });

  HrO2DataOwner.fromJson(Map<String, dynamic> json)
      : hrO2Device = HrO2Device.fromJson(json['hrO2Device']),
        dataOwnerAtsign = json['dataOwnerAtsign'];

  Map<String, dynamic> toJson() => {
        'hrO2Device': hrO2Device.toJson(),
        'dataOwnerAtsign': dataOwnerAtsign,
      };
}
