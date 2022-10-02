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
  final _atClient = AtClientManager.getInstance().atClient;

  Hro2DataService._internal();

  factory Hro2DataService() {
    return _singleton;
  }

  Future<bool> delete(AtKey atKey) async {
    return _atClient.delete(atKey);
  }

  Future<bool> deleteAllForKey(String key) async {
    var atKeys = await _atClient.getAtKeys(regex: key);
    for (var atKey in atKeys) {
      await delete(atKey);
    }
    return true;
  }

  Future<bool> deleteAllData() async {
    var keyStrings = AppConstants().listAllKeys;
    for (var key in keyStrings) {
      AtKey atKey = AtKey()..key = key;
      await delete(atKey);
      _logger.info('deleteAllData deleting ${atKey.toString()}');
    }
    return true;
  }

  Future<List<HrO2Device>> getDevices() async {
    List<HrO2Device> hrO2DeviceList = [];
    var atClient = _atClient;
    var keys = await atClient.getAtKeys(regex: AppConstants.deviceKey);
    for (var element in keys) {
      var data = await atClient.get(element);
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
    return hrO2DeviceList;
  }

  Future<bool> putDevice(HrO2Device hrO2Device) async {
    AtKey atKey = AtKey()..key = AppConstants.deviceKey;
    var value = jsonEncode(hrO2Device);
    var response = await _atClient.put(atKey, value);
    _logger.info('putDeviceList success = $response');
    return response;
  }

  Future<bool> deleteDevice(HrO2Device hrO2Device) async {
    List<AtKey> keys = await _atClient.getAtKeys(regex: AppConstants.deviceKey);
    _logger.info('deleteDevice processing ${keys.length} items');
    for (var key in keys) {
      var data = await _atClient.get(key);
      if (data.value == hrO2Device) {
        _logger.info('deleteDevice deleting $key');
        delete(key);
      }
    }
    return true;
  }

  // Future<List<HrO2Device>> getDeviceList() async {
  //   AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
  //   var data = await _atClient.get(atKey);
  //   _logger.info('getDeviceList got ${data.value}');
  //   List<HrO2Device> hrO2DeviceList;
  //   hrO2DeviceList = (json.decode(data.value) as List)
  //       .map((i) => HrO2Device.fromJson(i))
  //       .toList();
  //   _logger.info('getDeviceList returning $hrO2DeviceList');
  //   return hrO2DeviceList;
  // }

  // Future<bool> putDeviceList(List<HrO2Device> hrO2DeviceList) async {
  //   AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
  //   var value = jsonEncode(hrO2DeviceList);
  //   var response = await _atClient.put(atKey, value);
  //   _logger.info('putDeviceList success = $response');
  //   return response;
  // }

  // Future<bool> addDeviceToList(HrO2Device hrO2Device) async {
  //   List<HrO2Device> deviceList = [];
  //   deviceList = await getDeviceList().onError((error, stackTrace) async {
  //     return deviceList;
  //   });
  //   deviceList.add(hrO2Device);
  //   AtKey atKey = AtKey()..key = AppConstants.deviceListKey;
  //   var value = jsonEncode(deviceList);
  //   var response = await _atClient.put(atKey, value);
  //   _logger.info('addDeviceToList success = $response');
  //   return response;
  // }

  Future<List<HrO2Receiver>> getReceivers() async {
    List<HrO2Receiver> hrO2ReceiverList = [];
    var atClient = _atClient;
    var keys = await atClient.getAtKeys(regex: AppConstants.receiverKey);
    for (var element in keys) {
      var data = await atClient.get(element);
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
    AtKey atKey = AtKey()..key = AppConstants.receiverKey;
    var value = jsonEncode(hrO2Receiver);
    var success = await _atClient.put(atKey, value);
    _logger.info('putReceiver success = $success');
    // now, share the list with the device
    List<HrO2Receiver> receiverList = await getReceivers();
    atKey.key = AppConstants.receiverListKey;
    atKey.sharedWith = hrO2Receiver.hrO2Device.deviceAtsign;
    var receiverSuccess = await _atClient.put(atKey, jsonEncode(receiverList));
    _logger.info('putReceiver success = $receiverSuccess');
    return success && receiverSuccess;
  }

  Future<bool> deleteReceiver(HrO2Receiver hrO2Receiver) async {
    List<AtKey> keys =
        await _atClient.getAtKeys(regex: AppConstants.receiverKey);
    _logger.info('deleteDevice processing ${keys.length} items');
    for (var key in keys) {
      var data = await _atClient.get(key);
      if (data.value == hrO2Receiver) {
        _logger.info('deleteReceiver deleting $key');
        delete(key);
      }
    }
    return true;
  }

  // Future<List<HrO2Receiver>> getReceiverList() async {
  //   AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
  //   var data = await _atClient.get(atKey);
  //   _logger.info('getReceiverList got ${data.value}');
  //   List<HrO2Receiver> hrO2ReceiverList;
  //   hrO2ReceiverList = (json.decode(data.value) as List)
  //       .map((i) => HrO2Receiver.fromJson(i))
  //       .toList();
  //   _logger.info('getReceiverList returning $hrO2ReceiverList');
  //   return hrO2ReceiverList;
  // }

  // Future<bool> putReceiverList(List<HrO2Receiver> hrO2ReceiverList) async {
  //   AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
  //   var value = jsonEncode(hrO2ReceiverList);
  //   var response = await _atClient.put(atKey, value);
  //   _logger.info('putReceiverList success = $response');
  //   return response;
  // }

  // Future<bool> addReceiver(HrO2Receiver hrO2Receiver) async {
  //   List<HrO2Receiver> receiverList = [];
  //   receiverList = await getReceiverList().onError((error, stackTrace) async {
  //     return receiverList;
  //   });
  //   receiverList.add(hrO2Receiver);
  //   AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
  //   var receiverListJson = jsonEncode(receiverList);
  //   var receiverSuccess = await AtClientManager.getInstance()
  //       .atClient
  //       .put(atKey, receiverListJson);
  //   _logger.info('addReceiverToList success = $receiverSuccess');
  //   AtKey dataOwnerKey = AtKey()
  //     ..key = AppConstants.deviceReceiverKey
  //     ..sharedWith = hrO2Receiver.receiverAtsign;
  //   var sharedReceiverJson = jsonEncode(hrO2Receiver);
  //   var sharedReceiverSuccess = await AtClientManager.getInstance()
  //       .atClient
  //       .put(dataOwnerKey, sharedReceiverJson);
  //   _logger.info('shareDeviceSuccess success = $sharedReceiverSuccess');
  //   atKey.sharedWith = hrO2Receiver.hrO2Device.deviceAtsign;
  //   var deviceReceiverSuccess = await AtClientManager.getInstance()
  //       .atClient
  //       .put(atKey, receiverListJson);
  //   _logger.info('deviceDataOwnerSuccess success = $deviceReceiverSuccess');
  //   return receiverSuccess && deviceReceiverSuccess;
  // }

  // Future<bool> addReceiverToList(HrO2Receiver hrO2Receiver) async {
  //   List<HrO2Receiver> receiverList = [];
  //   receiverList = await getReceiverList().onError((error, stackTrace) async {
  //     return receiverList;
  //   });
  //   receiverList.add(hrO2Receiver);
  //   AtKey atKey = AtKey()..key = AppConstants.receiverListKey;
  //   var receiverListJson = jsonEncode(receiverList);
  //   var receiverSuccess = await AtClientManager.getInstance()
  //       .atClient
  //       .put(atKey, receiverListJson);
  //   _logger.info('addReceiverToList success = $receiverSuccess');
  //   AtKey dataOwnerKey = AtKey()
  //     ..key = AppConstants.deviceReceiverKey
  //     ..sharedWith = hrO2Receiver.receiverAtsign;
  //   var sharedReceiverJson = jsonEncode(hrO2Receiver);
  //   var sharedReceiverSuccess = await AtClientManager.getInstance()
  //       .atClient
  //       .put(dataOwnerKey, sharedReceiverJson);
  //   _logger.info('shareDeviceSuccess success = $sharedReceiverSuccess');
  //   atKey.sharedWith = hrO2Receiver.hrO2Device.deviceAtsign;
  //   var deviceReceiverSuccess = await AtClientManager.getInstance()
  //       .atClient
  //       .put(atKey, receiverListJson);
  //   _logger.info('deviceDataOwnerSuccess success = $deviceReceiverSuccess');
  //   return receiverSuccess && deviceReceiverSuccess;
  // }

  Future<List<HrO2DataOwner>> getDataOwners() async {
    List<HrO2DataOwner> hrO2DataOwnerList = [];
    var keys = await _atClient.getAtKeys(regex: AppConstants.dataOwnerKey);
    for (var element in keys) {
      var data = await _atClient.get(element);
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
    AtKey atKey = AtKey()..key = AppConstants.dataOwnerKey;
    var success = await _atClient.put(atKey, jsonEncode(hrO2DataOwner));
    _logger.info('putDataOwner success = $success');
    List<HrO2DataOwner> owners = await getDataOwners();
    atKey.key = AppConstants.dataOwnerListKey;
    atKey.sharedWith = hrO2DataOwner.hrO2Device.deviceAtsign;
    var dataOwnerSuccess = await _atClient.put(atKey, jsonEncode(owners));
    _logger.info('putDataOwner success = $dataOwnerSuccess');
    return success && dataOwnerSuccess;
  }

  // Future<List<HrO2DataOwner>> getDataOwnerList() async {
  //   AtKey atKey = AtKey()..key = AppConstants.dataOwnerListKey;
  //   var data = await _atClient.get(atKey);
  //   _logger.info('getDataOwnerList got ${data.value}');
  //   List<HrO2DataOwner> hrO2DataOwnerList;
  //   hrO2DataOwnerList = (json.decode(data.value) as List)
  //       .map((i) => HrO2DataOwner.fromJson(i))
  //       .toList();
  //   _logger.info('getDataOwnerList returning $hrO2DataOwnerList');
  //   return hrO2DataOwnerList;
  // }

//   Future<List<HrO2DataOwner>> getDeviceDataOwnerList() async {
//     AtKey atKey = AtKey()
//       ..key = AppConstants.deviceDataOwnerKey
//       ..sharedBy = "@mwcmanager";
//     var data = await _atClient.get(atKey);
//     _logger.info('getDeviceDataOwner got ${data.value}');
//     HrO2DataOwner hrO2DataOwner =
//         HrO2DataOwner.fromJson(json.decode(data.value));
//     List<HrO2DataOwner> hrO2DataOwnerList = [];
//     hrO2DataOwnerList.add(hrO2DataOwner);
//     _logger.info('getDeviceDataOwnerList returning $hrO2DataOwnerList');
//     return hrO2DataOwnerList;
//   }

//   Future<bool> putDataOwnerList(List<HrO2DataOwner> hrO2DataOwnerList) async {
//     AtKey atKey = AtKey()..key = AppConstants.dataOwnerListKey;
//     var value = jsonEncode(hrO2DataOwnerList);
//     var response = await _atClient.put(atKey, value);
//     _logger.info('putDataOwnerList success = $response');
//     return response;
//   }

//   Future<bool> addDataOwnerToList(HrO2DataOwner hrO2DataOwner) async {
//     List<HrO2DataOwner> dataOwnerList = [];
//     dataOwnerList = await getDataOwnerList().onError((error, stackTrace) async {
//       return dataOwnerList;
//     });
//     dataOwnerList.add(hrO2DataOwner);
//     AtKey listKey = AtKey()..key = AppConstants.dataOwnerListKey;
//     var dataOwnerListJson = jsonEncode(dataOwnerList);
//     var deviceOwnerSuccess = await AtClientManager.getInstance()
//         .atClient
//         .put(listKey, dataOwnerListJson);
//     _logger.info('addDataOwnerToList success = $deviceOwnerSuccess');
// // share information to the data owner
//     var sharedDataOwnerJson = jsonEncode(hrO2DataOwner);
//     AtKey dataOwnerKey = AtKey()
//       ..key = AppConstants.deviceDataOwnerKey
//       ..sharedWith = hrO2DataOwner.dataOwnerAtsign;
//     var sharedDataOwnerSuccess = await AtClientManager.getInstance()
//         .atClient
//         .put(dataOwnerKey, sharedDataOwnerJson);
//     _logger.info('shareDeviceSuccess success = $sharedDataOwnerSuccess');
//     // Share the list to the device
//     dataOwnerKey.sharedWith = hrO2DataOwner.hrO2Device.deviceAtsign;
//     var deviceDataOwnerSuccess = await AtClientManager.getInstance()
//         .atClient
//         .put(listKey, dataOwnerListJson);
//     _logger.info('deviceDataOwnerSuccess success = $deviceDataOwnerSuccess');
//     return deviceOwnerSuccess &&
//         sharedDataOwnerSuccess &&
//         deviceDataOwnerSuccess;
//   }

  Future<List<HrO2DeviceOwner>> getDeviceOwners() async {
    List<HrO2DeviceOwner> hrO2DeviceOwnerList = [];
    var keys = await _atClient.getAtKeys(regex: AppConstants.deviceOwnerKey);
    for (var element in keys) {
      var deviceOwnerData = await _atClient.get(element);
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
    var response = await _atClient.put(atKey, jsonEncode(hrO2DeviceOwner));
    _logger.info('putDeviceOwner success = $response');
    return response;
  }

  Future<bool> deleteDeviceOwner(HrO2DeviceOwner hrO2DeviceOwner) async {
    List<AtKey> keys =
        await _atClient.getAtKeys(regex: AppConstants.deviceOwnerKey);
    _logger.info('deleteDeviceOwner processing ${keys.length} items');
    for (var key in keys) {
      var data = await _atClient.get(key);
      if (data.value == hrO2DeviceOwner) {
        _logger.info('deleteReceiver deleting $key');
        delete(key);
      }
    }
    return true;
  }

//   Future<List<HrO2DeviceOwner>> getDeviceOwnerList() async {
//     AtKey atKey = AtKey()..key = AppConstants.deviceOwnerListKey;
//     var data = await _atClient.get(atKey);
//     _logger.info('getDeviceOwnerList got ${data.value}');
//     List<HrO2DeviceOwner> hrO2DeviceOwnerList;
//     hrO2DeviceOwnerList = (json.decode(data.value) as List)
//         .map((i) => HrO2DeviceOwner.fromJson(i))
//         .toList();
//     _logger.info('getDeviceOwnerList returning $hrO2DeviceOwnerList');
//     return hrO2DeviceOwnerList;
//   }

//   Future<List<HrO2DeviceOwner>> getDeviceDeviceOwnerList() async {
//     AtKey atKey = AtKey()
//       ..key = AppConstants.deviceOwnerKey
//       ..sharedBy = "@mwcmanager";
//     var data = await _atClient.get(atKey);
//     _logger.info('getDeviceOwner got ${data.value}');
//     HrO2DeviceOwner hrO2DeviceOwner =
//         HrO2DeviceOwner.fromJson(json.decode(data.value));
//     List<HrO2DeviceOwner> hrO2DeviceOwnerList = [];
//     hrO2DeviceOwnerList.add(hrO2DeviceOwner);
//     _logger.info('getDeviceOwnerList returning $hrO2DeviceOwnerList');
//     return hrO2DeviceOwnerList;
//   }

//   Future<bool> putDeviceOwnerList(
//       List<HrO2DeviceOwner> hrO2DeviceOwnerList) async {
//     AtKey atKey = AtKey()..key = AppConstants.dataOwnerListKey;
//     var value = jsonEncode(hrO2DeviceOwnerList);
//     var response = await _atClient.put(atKey, value);
//     _logger.info('putDeviceOwnerList success = $response');
//     return response;
//   }

//   Future<bool> addDeviceOwnerToList(HrO2DeviceOwner hrO2DeviceOwner) async {
//     List<HrO2DeviceOwner> dataOwnerList = [];
//     dataOwnerList =
//         await getDeviceOwnerList().onError((error, stackTrace) async {
//       return dataOwnerList;
//     });
//     dataOwnerList.add(hrO2DeviceOwner);
//     AtKey listKey = AtKey()..key = AppConstants.dataOwnerListKey;
//     var dataOwnerListJson = jsonEncode(dataOwnerList);
//     var deviceOwnerSuccess = await AtClientManager.getInstance()
//         .atClient
//         .put(listKey, dataOwnerListJson);
//     _logger.info('addDeviceOwnerToList success = $deviceOwnerSuccess');
// // share information to the data owner
//     var sharedDeviceOwnerJson = jsonEncode(hrO2DeviceOwner);
//     AtKey dataOwnerKey = AtKey()
//       ..key = AppConstants.deviceDeviceOwnerKey
//       ..sharedWith = hrO2DeviceOwner.dataOwnerAtsign;
//     var sharedDeviceOwnerSuccess = await AtClientManager.getInstance()
//         .atClient
//         .put(dataOwnerKey, sharedDeviceOwnerJson);
//     _logger.info('shareDeviceSuccess success = $sharedDeviceOwnerSuccess');
//     // Share the list to the device
//     dataOwnerKey.sharedWith = hrO2DeviceOwner.hrO2Device.deviceAtsign;
//     var deviceOwnerSuccess = await AtClientManager.getInstance()
//         .atClient
//         .put(listKey, dataOwnerListJson);
//     _logger
//         .info('deviceDeviceOwnerSuccess success = $deviceDeviceOwnerSuccess');
//     return deviceOwnerSuccess &&
//         sharedDeviceOwnerSuccess &&
//         deviceDeviceOwnerSuccess;
//   }
}

class AppConstants {
  static const String libraryNamespace = 'iot_receiver';
  static const String deviceListKey = 'device_list.$libraryNamespace';
  static const String deviceKey = 'device.$libraryNamespace';
  static const String receiverKey = 'receiver.$libraryNamespace';
  static const String dataOwnerKey = 'data_owner.$libraryNamespace';
  static const String deviceOwnerKey = 'device_owner.$libraryNamespace';
  static const String receiverListKey = 'receiver_list.$libraryNamespace';
  static const String dataOwnerListKey = 'data_owner_list.$libraryNamespace';
  static const String deviceOwnerListKey =
      'device_owner_list.$libraryNamespace';
  static const String deviceDataOwnerKey =
      'device_data_owner.$libraryNamespace';
  static const String deviceReceiverKey = 'device_receiver.$libraryNamespace';
  static const int responseTimeLimit = 30;
  List<String> listAllKeys = [
    deviceListKey,
    deviceKey,
    receiverKey,
    dataOwnerKey,
    receiverListKey,
    dataOwnerListKey,
    deviceDataOwnerKey,
    deviceReceiverKey,
  ];
}
