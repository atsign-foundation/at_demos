import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_utils/at_logger.dart';
import 'package:iot_receiver/models/hro2_data_owner.dart';
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
    AtKey dataOwnerAtKey = AtKey()..key = AppConstants.dataOwnerListKey;
    var dataOwnerKeyDeleted = await delete(dataOwnerAtKey);
    _logger.info('deleteAllData.dataOwnerKeyDeleted $dataOwnerKeyDeleted');
    return (deviceKeyDeleted && receiverKeyDeleted && dataOwnerKeyDeleted);
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
    var receiverSuccess =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('addReceiverToList success = $receiverSuccess');
    AtKey dataOwnerKey = AtKey()
      ..key = AppConstants.deviceReceiverKey
      ..sharedWith = hrO2Receiver.receiverAtsign;
    var sharedReceiverJson = jsonEncode(hrO2Receiver);
    var sharedReceiverSuccess = await AtClientManager.getInstance()
        .atClient
        .put(dataOwnerKey, sharedReceiverJson);
    _logger.info('shareDeviceSuccess success = $sharedReceiverSuccess');
    return receiverSuccess && receiverSuccess;
  }

  Future<List<HrO2DataOwner>> getDataOwnerList() async {
    AtKey atKey = AtKey()..key = AppConstants.dataOwnerListKey;
    var data = await AtClientManager.getInstance().atClient.get(atKey);
    _logger.info('getDataOwnerList got ${data.value}');
    List<HrO2DataOwner> hrO2DataOwnerList;
    hrO2DataOwnerList = (json.decode(data.value) as List)
        .map((i) => HrO2DataOwner.fromJson(i))
        .toList();
    _logger.info('getDataOwnerList returning $hrO2DataOwnerList');
    return hrO2DataOwnerList;
  }

  Future<List<HrO2DataOwner>> getDeviceDataOwnerList() async {
    AtKey atKey = AtKey()
      ..key = AppConstants.deviceDataOwnerKey
      ..sharedBy = "@mwcmanager";
    var data = await AtClientManager.getInstance().atClient.get(atKey);
    _logger.info('getDeviceDataOwner got ${data.value}');
    HrO2DataOwner hrO2DataOwner =
        HrO2DataOwner.fromJson(json.decode(data.value));
    List<HrO2DataOwner> hrO2DataOwnerList = [];
    hrO2DataOwnerList.add(hrO2DataOwner);
    _logger.info('getDeviceDataOwnerList returning $hrO2DataOwnerList');
    return hrO2DataOwnerList;
  }

  Future<bool> putDataOwnerList(List<HrO2DataOwner> hrO2DataOwnerList) async {
    AtKey atKey = AtKey()..key = AppConstants.dataOwnerListKey;
    var value = jsonEncode(hrO2DataOwnerList);
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putDataOwnerList success = $response');
    return response;
  }

  Future<bool> addDataOwnerToList(HrO2DataOwner hrO2DataOwner) async {
    List<HrO2DataOwner> dataOwnerList = [];
    dataOwnerList = await getDataOwnerList().onError((error, stackTrace) async {
      return dataOwnerList;
    });
    dataOwnerList.add(hrO2DataOwner);
    AtKey deviceOwnerKey = AtKey()..key = AppConstants.dataOwnerListKey;
    var dataOwnerJson = jsonEncode(dataOwnerList);
    var deviceOwnerSuccess = await AtClientManager.getInstance()
        .atClient
        .put(deviceOwnerKey, dataOwnerJson);
    _logger.info('addDataOwnerToList success = $deviceOwnerSuccess');
// share information to the data owner
    var sharedDataOwnerJson = jsonEncode(hrO2DataOwner);
    AtKey dataOwnerKey = AtKey()
      ..key = AppConstants.deviceDataOwnerKey
      ..sharedWith = hrO2DataOwner.dataOwnerAtsign;
    var sharedDataOwnerSuccess = await AtClientManager.getInstance()
        .atClient
        .put(dataOwnerKey, sharedDataOwnerJson);
    _logger.info('shareDeviceSuccess success = $sharedDataOwnerSuccess');
    // Share the same object to the device
    dataOwnerKey.sharedWith = hrO2DataOwner.hrO2Device.deviceAtsign;
    var deviceDataOwnerSuccess = await AtClientManager.getInstance()
        .atClient
        .put(dataOwnerKey, sharedDataOwnerJson);
    _logger.info('deviceDataOwnerSuccess success = $deviceDataOwnerSuccess');
    return deviceOwnerSuccess &&
        sharedDataOwnerSuccess &&
        deviceDataOwnerSuccess;
  }
}

class AppConstants {
  static const String libraryNamespace = 'iot_receiver';
  static const String deviceListKey = 'device_list.$libraryNamespace';
  static const String receiverListKey = 'receiver_list.$libraryNamespace';
  static const String dataOwnerListKey = 'data_owner_list.$libraryNamespace';
  static const String deviceDataOwnerKey =
      'device_data_owner.$libraryNamespace';
  static const String deviceReceiverKey = 'device_receiver.$libraryNamespace';
  static const int responseTimeLimit = 30;
}
