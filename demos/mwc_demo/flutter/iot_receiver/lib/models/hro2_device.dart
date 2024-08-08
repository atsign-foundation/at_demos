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
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => deviceUuid.hashCode;
}
