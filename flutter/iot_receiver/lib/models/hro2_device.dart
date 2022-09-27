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
