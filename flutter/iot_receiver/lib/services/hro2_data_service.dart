import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_utils/at_logger.dart';
import 'package:iot_receiver/models/hro2_data_owner.dart';
import 'package:iot_receiver/models/hro2_device.dart';
import 'package:iot_receiver/models/hro2_device_owner.dart';
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

  Future<bool> deleteAllForKey(String key) async {
    var atKeys =
        await AtClientManager.getInstance().atClient.getAtKeys(regex: key);
    for (var atKey in atKeys) {
      await delete(atKey);
    }
    return true;
  }

  Future<bool> deleteAllData() async {
    var keyStrings = AppConstants().listAllKeys;
    for (var key in keyStrings) {
      _logger.info('deleteAllData deleting $key');
      await deleteAllForKey(key);
    }
    return true;
  }

  Future<List<HrO2Device>> getDevices() async {
    List<HrO2Device> hrO2DeviceList = [];
    // var atClient = AtClientManager.getInstance().atClient;
    var keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.deviceKey);
    for (var element in keys) {
      var data = await AtClientManager.getInstance().atClient.get(element);
      _logger.info('getDevices got ${data.value}');
      try {
        HrO2Device hrO2Device = HrO2Device.fromJson(jsonDecode(data.value));
        hrO2DeviceList.add(hrO2Device);
      } catch (error) {
        // found some dirty data, consider deleting
        _logger.severe('getDevices error $error for ${element.key}');
        // await atClient.delete(element);
      }
    }
    _logger.info('getDevices returning $hrO2DeviceList');
    return hrO2DeviceList;
  }

  Future<bool> putDevice(HrO2Device hrO2Device) async {
    AtKey atKey = AtKey()..key = AppConstants.deviceKey;
    var value = jsonEncode(hrO2Device);
    var response =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putDeviceList success = $response');
    return response;
  }

  Future<bool> deleteDevice(HrO2Device hrO2Device) async {
    bool response = false;
    List<AtKey> keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.deviceKey);
    _logger.info('deleteDevice processing ${keys.length} items');
    for (var key in keys) {
      AtValue data = await AtClientManager.getInstance().atClient.get(key);
      var atKeyString = jsonDecode(data.value);
      HrO2Device device = HrO2Device.fromJson(atKeyString);
      if (device.deviceAtsign == hrO2Device.deviceAtsign) {
        _logger.info(
            'deleteReceiver deleting ${hrO2Device.deviceAtsign}\'s entry');
        response = await delete(key);
      }
    }
    return response;
  }

  Future<List<HrO2Receiver>> getReceivers() async {
    List<HrO2Receiver> hrO2ReceiverList = [];
    // var atClient = _atClient;
    var keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.receiverKey);
    for (var element in keys) {
      var data = await AtClientManager.getInstance().atClient.get(element);
      _logger.info('getReceivers got ${data.value}');
      try {
        HrO2Receiver hrO2Receiver =
            HrO2Receiver.fromJson(jsonDecode(data.value));
        hrO2ReceiverList.add(hrO2Receiver);
      } catch (error) {
        // found some dirty data, consider deleting
        _logger.severe('getReceivers error $error for ${element.key}');
        // await atClient.delete(element);
      }
    }
    _logger.info('getReceivers returning ${hrO2ReceiverList.toString()}');
    return hrO2ReceiverList;
  }

  Future<bool> putReceiver(HrO2Receiver hrO2Receiver) async {
    AtKey atKey = AtKey()
      ..sharedWith = hrO2Receiver.receiverAtsign
      ..key = AppConstants.receiverKey;
    var value = jsonEncode(hrO2Receiver);
    var success =
        await AtClientManager.getInstance().atClient.put(atKey, value);
    _logger.info('putReceiver success = $success');
    var receiverSuccess = await updateDeviceReceivers(hrO2Receiver.hrO2Device);
    return success && receiverSuccess;
  }

  Future<bool> deleteReceiver(HrO2Receiver hrO2Receiver) async {
    bool deleteSuccess = false;
    bool deviceUpdated = false;
    List<AtKey> keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.receiverKey);
    _logger.info('deleteReceiver processing ${keys.length} items');
    for (var key in keys) {
      AtValue data = await AtClientManager.getInstance().atClient.get(key);
      var atKeyString = jsonDecode(data.value);
      HrO2Receiver rec = HrO2Receiver.fromJson(atKeyString);
      if (rec.receiverAtsign == hrO2Receiver.receiverAtsign) {
        _logger.info(
            'deleteReceiver deleting ${hrO2Receiver.receiverAtsign}\'s entry');
        deleteSuccess = await delete(key);
        deviceUpdated = await updateDeviceReceivers(hrO2Receiver.hrO2Device);
      }
    }
    return deleteSuccess && deviceUpdated;
  }

  Future<List<HrO2DataOwner>> getDataOwners() async {
    List<HrO2DataOwner> hrO2DataOwnerList = [];
    var keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.dataOwnerKey, sharedBy: "@mwcmanager");
    for (var element in keys) {
      var data = await AtClientManager.getInstance().atClient.get(element);
      _logger.info('getDataOwners got ${data.value}');
      try {
        HrO2DataOwner hrO2DataOwner =
            HrO2DataOwner.fromJson(jsonDecode(data.value));
        hrO2DataOwnerList.add(hrO2DataOwner);
      } catch (error) {
        // found some dirty data, consider deleting
        _logger.severe('getDataOwners error $error for ${element.key}');
        // await atClient.delete(element);
      }
    }
    return hrO2DataOwnerList;
  }

  Future<bool> putDataOwner(HrO2DataOwner hrO2DataOwner) async {
    AtClientManager.getInstance().syncService.sync();
    AtKey atKey = AtKey()
      ..sharedWith = hrO2DataOwner.dataOwnerAtsign
      ..key = AppConstants.dataOwnerKey;
    var success = await AtClientManager.getInstance()
        .atClient
        .put(atKey, jsonEncode(hrO2DataOwner));
    _logger.info('putDataOwner success = $success');
    var dataOwnerSuccess =
        await updateDeviceDataOwners(hrO2DataOwner.hrO2Device);
    _logger.info('putDataOwner updateDevice success = $dataOwnerSuccess');
    return success && dataOwnerSuccess;
  }

  Future<bool> deleteDataOwner(HrO2DataOwner hrO2DataOwner) async {
    bool response = false;
    List<AtKey> keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.dataOwnerKey);
    _logger.info('deleteDataOwner processing ${keys.length} items');
    for (var key in keys) {
      AtValue data = await AtClientManager.getInstance().atClient.get(key);
      var atKeyString = jsonDecode(data.value);
      HrO2DataOwner owner = HrO2DataOwner.fromJson(atKeyString);
      if (owner.dataOwnerAtsign == hrO2DataOwner.dataOwnerAtsign) {
        _logger.info(
            'deleteDataOwner deleting ${hrO2DataOwner.dataOwnerAtsign}\'s entry');
        response = await delete(key);
      }
    }
    return response;
  }

  Future<List<HrO2DeviceOwner>> getDeviceOwners() async {
    List<HrO2DeviceOwner> hrO2DeviceOwnerList = [];
    var keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.deviceOwnerKey);
    for (var element in keys) {
      var deviceOwnerData =
          await AtClientManager.getInstance().atClient.get(element);
      _logger.info('getDeviceOwners got ${deviceOwnerData.value}');
      try {
        HrO2DeviceOwner hrO2DeviceOwner =
            HrO2DeviceOwner.fromJson(jsonDecode(deviceOwnerData.value));
        hrO2DeviceOwnerList.add(hrO2DeviceOwner);
      } catch (error) {
        // found some dirty data, consider deleting
        _logger.severe('getDeviceOwners error $error for ${element.key}');
        // await atClient.delete(element);
      }
    }
    return hrO2DeviceOwnerList;
  }

  Future<bool> putDeviceOwner(HrO2DeviceOwner hrO2DeviceOwner) async {
    AtKey atKey = AtKey()
      ..key = AppConstants.deviceOwnerKey
      ..sharedWith = hrO2DeviceOwner.deviceOwnerAtsign;
    var response = await AtClientManager.getInstance()
        .atClient
        .put(atKey, jsonEncode(hrO2DeviceOwner));
    _logger.info('putDeviceOwner success = $response');
    return response;
  }

  Future<bool> deleteDeviceOwner(HrO2DeviceOwner hrO2DeviceOwner) async {
    List<AtKey> keys = await AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: AppConstants.deviceOwnerKey);
    _logger.info('deleteDeviceOwner processing ${keys.length} items');
    for (var key in keys) {
      var data = await AtClientManager.getInstance().atClient.get(key);
      if (data.value == hrO2DeviceOwner) {
        _logger.info('deleteReceiver deleting $key');
        delete(key);
      }
    }
    return true;
  }

  Future<bool> updateDeviceReceivers(HrO2Device hrO2Device) async {
    // update the device list of HrO2Receiver objects
    AtKey atKey = AtKey()
      ..sharedWith = hrO2Device.deviceAtsign
      ..key = AppConstants.receiverListKey;
    List<HrO2Receiver> receiverList = await getReceivers();
    var success = await AtClientManager.getInstance()
        .atClient
        .put(atKey, jsonEncode(receiverList));
    _logger.info('updateDeviceReceivers success = $success');
    return success;
  }

  Future<bool> updateDeviceDataOwners(HrO2Device hrO2Device) async {
    // update the device list of HrO2DataOwner objects
    AtKey atKey = AtKey()
      ..sharedWith = hrO2Device.deviceAtsign
      ..key = AppConstants.dataOwnerListKey;
    List<HrO2DataOwner> owners = await getDataOwners();
    var success = await AtClientManager.getInstance()
        .atClient
        .put(atKey, jsonEncode(owners));
    _logger.info('updateDeviceDataOwners success = $success');
    return success;
  }
}

class AppConstants {
  static const String libraryNamespace = 'iot_receiver';
  static const String dataOwnerKey = 'data_owner.$libraryNamespace';
  static const String dataOwnerListKey = 'data_owner_list.$libraryNamespace';
  static const String deviceKey = 'device.$libraryNamespace';
  static const String deviceListKey = 'device_list.$libraryNamespace';
  static const String deviceOwnerKey = 'device_owner.$libraryNamespace';
  static const String deviceOwnerListKey =
      'device_owner_list.$libraryNamespace';
  static const String deviceDataOwnerKey =
      'device_data_owner.$libraryNamespace';
  static const String deviceReceiverKey = 'device_receiver.$libraryNamespace';
  static const String receiverKey = 'receiver.$libraryNamespace';
  static const int responseTimeLimit = 30;
  static const String receiverListKey = 'receiver_list.$libraryNamespace';
  List<String> listAllKeys = [
    dataOwnerKey,
    dataOwnerListKey,
    deviceKey,
    deviceListKey,
    deviceDataOwnerKey,
    deviceReceiverKey,
    receiverKey,
    receiverListKey,
  ];
}
