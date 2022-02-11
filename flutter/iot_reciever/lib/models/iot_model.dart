class IoT {
  String sensorName;
  String? heartRate;
  String? bloodOxygen;
  String? time;

  IoT({
    required this.sensorName,
    required this.heartRate,
    required this.bloodOxygen,
    this.time = '0',
  });

  IoT.fromJson(Map<String, dynamic> json)
      : sensorName = json['sensorName'],
        heartRate = json['heartRate'],
        bloodOxygen = json['bloodOxygen'],
        time = json['time'];

  IoT.fromJsonLong(Map<String, dynamic> json)
      : sensorName = json['"sensorName"']
            .toString()
            .replaceAll(RegExp('(^")|("\$)'), ''),
        heartRate =
            json['"heartRate"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        bloodOxygen = json['"bloodOxygen"'].toString().replaceAll(RegExp('(^")|("\$)'), ''),
        time =
            json['"time"'].toString().replaceAll(RegExp('(^")|("\$)'), '');

  Map<String, dynamic> toJson() => {
        'sensorName': sensorName,
        'heartRate': heartRate,
        'bloodOxygen': bloodOxygen,
        'time': time

      };

  Map<String, dynamic> toJsonLong() => {
        '"sensorName"': '"$sensorName"',
        '"heartRate"': '"$heartRate"',
        '"bloodOxygen"': '"$bloodOxygen"',
        '"time"': '"$time"',
      };
}
