class HrO2Device {
  String deviceAtsign;
  String deviceUuid;
  String sensorName;

  HrO2Device({
    required this.deviceAtsign,
    required this.deviceUuid,
    required this.sensorName,
  });

  HrO2Device.fromJson(Map<String, dynamic> json)
      : deviceAtsign = json['deviceAtsign'],
        deviceUuid = json['deviceUuid'],
        sensorName = json['sensorName'];

  Map<String, dynamic> toJson() => {
        'deviceAtsign': deviceAtsign,
        'deviceUuid': deviceUuid,
        'sensorName': sensorName,
      };

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    // other != null && this.deviceUuid == other.deviceUuid;
    return true;
  }
}
