import 'dart:convert';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_utils/at_logger.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/models/hro2_receiver.dart';

class Hro2DataService {
  static final Hro2DataService _singleton = Hro2DataService._internal();

  final _logger = AtSignLogger('HrO2DataService');

  Hro2DataService._internal();

  factory Hro2DataService() {
    return _singleton;
  }

  Future<bool> delete(AtKey atKey) async {
    return AtClientManager.getInstance().atClient.delete(atKey);
  }

  Future<bool> deleteAllData() async {
    AtKey deviceAtKey = AtKey()..key = AppConstants.deviceListKey;
    var deviceKeyDeleted = await delete(deviceAtKey);
    _logger.info('deleteAllData.deviceKeyDeleted $deviceKeyDeleted');
    AtKey receiverAtKey = AtKey()..key = AppConstants.receiverListKey;
    var receiverKeyDeleted = await delete(receiverAtKey);
    _logger.info('deleteAllData.receiverKeyDeleted $receiverKeyDeleted');
    return (deviceKeyDeleted && receiverKeyDeleted);
  }

  ///Returns `AtFollowsValue` for [atKey].
  Future<List<HrO2Device>> getDeviceList() async {
    AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
    var data = await AtClientManager.getInstance().atClient.get(atKey);
    _logger.info('getDeviceList got ${data.value}');
    List<HrO2Device> hrO2DeviceList;
    hrO2DeviceList = (json.decode(data.value) as List)
        .map((i) => HrO2Device.fromJson(i))
        .toList();
    _logger.info('getDeviceList returning $hrO2DeviceList');
    return hrO2DeviceList;
  }

  Future<bool> putDeviceList(List<HrO2Device> hrO2DeviceList) async {
    AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
    var value = jsonEncode(hrO2DeviceList);
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putDeviceList success = $response');
    return response;
  }

  Future<bool> addDeviceToList(HrO2Device hrO2Device) async {
    List<HrO2Device> deviceList = [];
    deviceList = await getDeviceList().onError((error, stackTrace) async {
      return deviceList;
    });
    deviceList.add(hrO2Device);
    AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
    var value = jsonEncode(deviceList);
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('addDeviceToList success = $response');
    return response;
  }

  Future<List<HrO2Receiver>> getReceiverList() async {
    AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
    var data = await AtClientManager.getInstance().atClient.get(atKey);
    _logger.info('getReceiverList got ${data.value}');
    List<HrO2Receiver> hrO2ReceiverList;
    hrO2ReceiverList = (json.decode(data.value) as List)
        .map((i) => HrO2Receiver.fromJson(i))
        .toList();
    _logger.info('getReceiverList returning $hrO2ReceiverList');
    return hrO2ReceiverList;
  }

  Future<bool> putReceiverList(List<HrO2Receiver> hrO2ReceiverList) async {
    AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
    var value = jsonEncode(hrO2ReceiverList);
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putReceiverList success = $response');
    return response;
  }

  Future<bool> addReceiverToList(HrO2Receiver hrO2Receiver) async {
    List<HrO2Receiver> receiverList = [];
    receiverList = await getReceiverList().onError((error, stackTrace) async {
      return receiverList;
    });
    receiverList.add(hrO2Receiver);
    AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
    var value = jsonEncode(receiverList);
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('addReceiverToList success = $response');
    return response;
  }
}

class AppConstants {
  static const String libraryNamespace = 'iot_receiver';
  static const String deviceListKey = 'device_list.$libraryNamespace';
  static const String receiverListKey = 'receiver_list.$libraryNamespace';
  static const int responseTimeLimit = 30;
}
