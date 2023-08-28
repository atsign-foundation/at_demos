import 'dart:convert';

import 'package:iot_sender/models/hro2_data_owner.dart';
import 'package:iot_sender/models/hro2_device.dart';
import 'package:iot_sender/models/send_hr02_receiver.dart';

void main() {
  List<SendHrO2Receiver> toAtsigns = [];
  SendHrO2Receiver first =
      SendHrO2Receiver(receiverAtsign: '@atgps_receiver', sendHR: true, sendO2: true, receiverShortname: "world");
  SendHrO2Receiver second =
      SendHrO2Receiver(receiverAtsign: '@atgps02', sendHR: true, sendO2: false, receiverShortname: "hello");

  toAtsigns.add(first);
  toAtsigns.add(second);

  var p = jsonEncode(toAtsigns);
  print(' Encoded list of Receivers');
  print(p);

  // Simulate pulling a String from an atKey then Encode
  var j =
      '[{"receiverAtsign":"@atgps_receiver","sendHR":true,"sendO2":true,"receiverShortname":"world"},{"receiverAtsign":"@atgps02","sendHR":false,"sendO2":false,"receiverShortname":"hello"}]';

  List x = jsonDecode(j);

  // Pull some values directly
  print("Pull some values directly");
  print(x[0]['sendHR'].toString());
  print(x[1]['sendHR'].toString());

  for (var a = 0; a < x.length; a++) {
    toAtsigns.add(SendHrO2Receiver.fromJson(x[a]));
  }
  p = jsonEncode(toAtsigns);

  print(p);

// Now the same thing with Data Owners
//
  List<HrO2DataOwner> dataOwners = [];

  HrO2Device mwcpi = HrO2Device(deviceAtsign: '@mwcpi', deviceUuid: 'uuid01', sensorName: 'mwcpi');

  HrO2DataOwner firstDo = HrO2DataOwner(hrO2Device: mwcpi, dataOwnerAtsign: '@mwcpi');

  HrO2Device piw2 = HrO2Device(deviceAtsign: '@piw2', deviceUuid: 'uuid02', sensorName: 'piw2');

  HrO2DataOwner secondDo = HrO2DataOwner(hrO2Device: piw2, dataOwnerAtsign: '@piw2');

  dataOwners.add(firstDo);
  dataOwners.add(secondDo);

  String pp = jsonEncode(dataOwners);
  print(' Encoded list of DataOwners');
  print(pp);

  // Simulate pulling a String from an atKey then Encode

  var jj =
      '[{"hrO2Device":{"deviceAtsign":"@mwcpi","deviceUuid":"uuid01","sensorName":"mwcpi"},"dataOwnerAtsign":"@mwcpi"},{"hrO2Device":{"deviceAtsign":"@piw2","deviceUuid":"uuid02","sensorName":"piw2"},"dataOwnerAtsign":"@piw2"}]';

  List xx = jsonDecode(jj);

  // Pull some values directly
  print("Pull some values directly");
  print(xx[0]['hrO2Device']['deviceAtsign'].toString());
  print(xx[1]['hrO2Device']['deviceAtsign'].toString());

  for (var a = 0; a < xx.length; a++) {
    dataOwners.add(HrO2DataOwner.fromJson(xx[a]));
  }

  Set<HrO2DataOwner> dataOwnerAtsigns = {};

  for (var a = 0; a < xx.length; a++) {
    print(dataOwners[a].dataOwnerAtsign);
    dataOwnerAtsigns.add(dataOwners[a]);
  }
  pp = jsonEncode(dataOwners);

  print(pp);

  for (var a = 0; a < xx.length; a++) {
    print(dataOwnerAtsigns.toList()[a].dataOwnerAtsign + "," + dataOwnerAtsigns.toList()[a].hrO2Device.sensorName);
  }
  print('NNNNNNNNNNNNNNNNNNNNNNN');
  //Using a Set first dedupes the list we eventually send back
  Set<HrO2DataOwner> adataOwners = {};

  /// Todo Replace thsi string with a atKey.get from deviceowner dataowners.sensorname.namespace@deviceowner
  ///
  var dataOwnersJson =
      '[{"hrO2Device":{"deviceAtsign":"@mwcpi","deviceUuid":"uuid01","sensorName":"mwcpi"},"dataOwnerAtsign":"@wisefrog"},{"hrO2Device":{"deviceAtsign":"@piw2","deviceUuid":"uuid02","sensorName":"piw2"},"dataOwnerAtsign":"@happyclam"}]';

  List xxx = jsonDecode(dataOwnersJson);

  for (var a = 0; a < xxx.length; a++) {
    adataOwners.add(HrO2DataOwner.fromJson(xxx[a]));
  }

  for (HrO2DataOwner a in adataOwners) {
    var atsign = a.dataOwnerAtsign;
    var device = a.hrO2Device.sensorName;
    print(atsign + "," + device);
  }
}
