import 'dart:convert';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_utils/at_logger.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/models/hro2_receiver.dart';

class HrO2DataService {
  static final HrO2DataService _singleton = HrO2DataService._internal();

  late HrO2DeviceList devices;
  late HrO2ReceiverList receivers;

  final _logger = AtSignLogger('HrO2DataService');

  HrO2DataService._internal();

  factory HrO2DataService() {
    return _singleton;
  }

  Future<bool> delete(AtKey atKey) async {
    return await AtClientManager.getInstance().atClient.delete(atKey);
  }

  ///Returns `AtFollowsValue` for [atKey].
  Future<HrO2DeviceList> getDeviceList() async {
    AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
    var data = await AtClientManager.getInstance().atClient.get(atKey);
    _logger.info('getDeviceList got ${data.value}');
    var response = HrO2DeviceList(hrO2DeviceList: jsonDecode(data.value));
    _logger.info('getDeviceList returning $response');
    return response;
  }

  Future<bool> putDeviceList(HrO2DeviceList hrO2DeviceList) async {
    AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
    var value = jsonEncode(hrO2DeviceList.toJson());
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putDeviceList success = $response');
    return response;
  }

  Future<HrO2ReceiverList> getReceiverList() async {
    AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
    var data = await AtClientManager.getInstance().atClient.get(atKey);
    _logger.info('getReceiverList got ${data.value}');
    var response = HrO2ReceiverList(hrO2ReceiverList: jsonDecode(data.value));
    _logger.info('getReceiverList returning $response');
    return response;
  }

  Future<bool> putReceiverList(HrO2ReceiverList hrO2ReceiverList) async {
    AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
    var value = jsonEncode(hrO2ReceiverList.toJson());
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putReceiverList success = $response');
    return response;
  }
}

class AppConstants {
  static const String libraryNamespace = 'iot_receiver';
  static const String deviceListKey = 'device_list.$libraryNamespace';
  static const String receiverListKey = 'receiver_list.$libraryNamespace';
  static const int responseTimeLimit = 30;
}
