class HrO2Device {
  String deviceAtsign;
  String deviceUuid;

  HrO2Device({
    required this.deviceAtsign,
    required this.deviceUuid,
  });

  HrO2Device.fromJson(Map<String, dynamic> json)
      : deviceAtsign = json['deviceAtsign'],
        deviceUuid = json['deviceUuid'];

  Map<String, dynamic> toJson() => {
        'deviceAtsign': deviceAtsign,
        'deviceUuid': deviceUuid,
      };
}

class HrO2DeviceList {
  late List<HrO2Device> hrO2DeviceList;

  HrO2DeviceList({
    required this.hrO2DeviceList,
  });

  List<Map<String, dynamic>>? toJson() {
    List<Map<String, dynamic>>? devices =
        hrO2DeviceList.map((i) => i.toJson()).toList();
    return devices;
  }

  factory HrO2DeviceList.fromJson(dynamic json) {
    List<HrO2Device> devices = json
        .map((hrO2DeviceListJson) => HrO2Device.fromJson(hrO2DeviceListJson))
        .toList();
    return HrO2DeviceList(hrO2DeviceList: devices);
  }
}
