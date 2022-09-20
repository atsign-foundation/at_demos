import 'dart:convert';

import 'package:iot_sender/models/send_hr02_receiver.dart';

void main() {
  List<SendHrO2Receiver> toAtsigns = [];
  SendHrO2Receiver first =
      SendHrO2Receiver(sendToAtsign: '@atgps_receiver', sendHR: true, sendO2: true, sendToShortname: "world");
  SendHrO2Receiver second =
      SendHrO2Receiver(sendToAtsign: '@atgps02', sendHR: true, sendO2: false, sendToShortname: "hello");

  toAtsigns.add(first);
  toAtsigns.add(second);

  var p = jsonEncode(toAtsigns);

  print(p);

  var j =
      '[{"sendToAtsign":"@atgps_receiver","sendHR":true,"sendO2":true,"sendToShortname":"world"},{"sendToAtsign":"@atgps02","sendHR":true,"sendO2":false,"sendToShortname":"hello"}]';

  var x = jsonDecode(j);

  print(x[0]['sendHR']);


  for (var a = 0; a < x.length; a++) {
    toAtsigns.add(SendHrO2Receiver.fromJson(x[a]));
  }
   p = jsonEncode(toAtsigns);

  print(p);

}
