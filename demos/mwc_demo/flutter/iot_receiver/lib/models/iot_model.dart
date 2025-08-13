class IoT {
  String sensorName;
  String currentAtsign;
  String? heartRate;
  String? bloodOxygen;
  String? meterHeartRate;
  String? meterBloodOxygen;
  String? heartTime;
  String? oxygenTime;

  IoT(
      {required this.sensorName,
      required this.heartRate,
      required this.bloodOxygen,
      this.currentAtsign = '',
      this.meterBloodOxygen = '0',
      this.meterHeartRate = '0',
      this.heartTime = '0',
      this.oxygenTime = '0'});

  IoT.fromJson(Map<String, dynamic> json)
      : sensorName = json['sensorName'],
        currentAtsign = json['currentAtsign'],
        heartRate = json['heartRate'],
        bloodOxygen = json['bloodOxygen'],
        heartTime = json['heartTime'],
        oxygenTime = json['oxygenTime'];

  IoT.fromJsonLong(Map<String, dynamic> json)
      : sensorName = json['"sensorName"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        currentAtsign = json['"currentAtsign"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        heartRate = json['"heartRate"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        bloodOxygen = json['"bloodOxygen"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        heartTime = json['"heartTime"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        oxygenTime = json['"oxygenTime"'].toString().replaceAll(RegExp('(^")|("\$)'), '');

  Map<String, dynamic> toJson() => {
        'sensorName': sensorName,
        'currentAtsign': currentAtsign,
        'heartRate': heartRate,
        'bloodOxygen': bloodOxygen,
        'heartTime': heartTime,
        'oxygenTime': oxygenTime
      };

  Map<String, dynamic> toJsonLong() => {
        '"sensorName"': '"$sensorName"',
        '"currentAtsign"': '"$currentAtsign"',
        '"heartRate"': '"$heartRate"',
        '"bloodOxygen"': '"$bloodOxygen"',
        '"heartTime"': '"$heartTime"',
        '"oxygenTime"': '"$bloodOxygen"'
      };
}
