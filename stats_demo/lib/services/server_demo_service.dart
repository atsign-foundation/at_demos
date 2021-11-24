import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:verbs_testing/utils/at_conf.dart';
import 'package:at_client/at_client.dart';
import 'package:at_client/src/service/notification_service.dart';
import 'package:at_client/src/response/default_response_parser.dart';
import 'package:at_client/src/preference/monitor_preference.dart';
import 'package:at_client/src/manager/monitor.dart';
import 'package:at_commons/at_builders.dart';
import 'package:at_utils/at_logger.dart';

class ServerDemoService {
  static final ServerDemoService _singleton = ServerDemoService._internal();

  ServerDemoService._internal();

  factory ServerDemoService.getInstance() => _singleton;

  AtClientService atClientServiceInstance;
  Map<String, AtClientService> atClientServiceMap = {};
  String atSign;
  List<AtNotification> myNotificationsList = [];
  List<AtNotification> sentNotificationsList = [];

  Monitor _monitorService;

  var _logger = AtSignLogger('Server Demo Service');

  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  AtClientManager _atClientManager = AtClientManager.getInstance();

  AtClientService getClientServiceForAtSign(String atsign) {
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign];
    }
    final service = AtClientService();
    return service;
  }

  Future<AtClientPreference> getAtClientPreference(String atSign) async {
    final appDocumentDirectory = await path_provider.getApplicationSupportDirectory();
    final path = appDocumentDirectory.path;
    final _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = at_demo_data.cramKeyMap[atSign]
      ..namespace = AtConfig.namespace
      ..rootDomain = AtConfig.root
      ..hiveStoragePath = path;

    return _atClientPreference;
  }

  checkAtSignStatus(String atsign) async {
    final atStatusImpl = AtStatusImpl(rootUrl: AtConfig.root);
    final status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  Future<void> storeDemoDataToKeychain(String atsign) async {
    const String KEYCHAIN_ENCRYPTION_PRIVATE_KEY = '_encryption_private_key';
    const String KEYCHAIN_ENCRYPTION_PUBLIC_KEY = '_encryption_public_key';
    const String KEYCHAIN_SELF_ENCRYPTION_KEY = '_aesKey';
    var decryptKey = at_demo_data.aesKeyMap[atsign];
    var pkamPublicKey = at_demo_data.pkamPublicKeyMap[atsign];

    var pkamPrivateKey = at_demo_data.pkamPrivateKeyMap[atsign];

    // Save pkam public/private key pair in keychain
    await _keyChainManager.storeCredentialToKeychain(atsign, privateKey: pkamPrivateKey, publicKey: pkamPublicKey);

    var encryptionPublicKey = at_demo_data.encryptionPublicKeyMap[atsign];
    await _keyChainManager.putValue(atsign, KEYCHAIN_ENCRYPTION_PUBLIC_KEY, encryptionPublicKey);

    var encryptionPrivateKey = at_demo_data.encryptionPrivateKeyMap[atsign];
    await _keyChainManager.putValue(atsign, KEYCHAIN_ENCRYPTION_PRIVATE_KEY, encryptionPrivateKey);
    await _keyChainManager.putValue(atsign, KEYCHAIN_SELF_ENCRYPTION_KEY, decryptKey);
  }

  ///persisting keys into keystore for [atSign].
  Future<void> persistKeys(String atSign) async {
    var pkamPublicKey = at_demo_data.pkamPublicKeyMap[atSign];

    var pkamPrivateKey = at_demo_data.pkamPrivateKeyMap[atSign];

    var encryptPrivateKey = at_demo_data.encryptionPrivateKeyMap[atSign];

    var encryptPublicKey = at_demo_data.encryptionPublicKeyMap[atSign];

    var selfEncryptionKey = at_demo_data.aesKeyMap[atSign];

    var atClient = _atClientManager.atClient;

    await atClient.getLocalSecondary().putValue(AT_PKAM_PUBLIC_KEY, pkamPublicKey);
    await atClient.getLocalSecondary().putValue(AT_PKAM_PRIVATE_KEY, pkamPrivateKey);
    await atClient.getLocalSecondary().putValue(AT_ENCRYPTION_PRIVATE_KEY, encryptPrivateKey);
    var updateBuilder = UpdateVerbBuilder()
      ..atKey = 'publickey'
      ..isPublic = true
      ..sharedBy = atSign
      ..value = encryptPublicKey;
    await atClient.getLocalSecondary().executeVerb(updateBuilder, sync: true);

    await atClient.getLocalSecondary().putValue(AT_ENCRYPTION_SELF_KEY, selfEncryptionKey);
  }

  Future<String> get(AtKey atKey) async {
    final result = await _atClientManager.atClient.get(atKey);
    return result.value;
  }

  Future<String> getFromNotification(AtNotification notification) async {
    var metadata = Metadata()..isCached = true;
    var atKey = AtKey()
      ..sharedBy = notification.fromAtSign
      ..sharedWith = notification.toAtSign
      ..key = notification.key
      ..metadata = metadata;
    var result = await this.get(atKey);
    return result;
  }

  Future<bool> put(AtKey atKey, String value) async => await _atClientManager.atClient.put(atKey, value);

  Future<bool> delete(AtKey atKey) async => await _atClientManager.atClient.delete(atKey);

  Future<List<AtKey>> getAtKeys({String sharedBy}) async => await _atClientManager.atClient.getAtKeys(
        regex: AtConfig.namespace,
        sharedBy: sharedBy,
      );

  ///Fetches atsign from device keychain.
  Future<String> getAtSign() async {
    return _atClientManager.atClient.getCurrentAtSign();
  }

  void startMonitoring(String atsign, Function notificationCallback) {
    _atClientManager.notificationService.subscribe(regex: AtConfig.namespace).listen(notificationCallback);
  }

  Monitor getMonitorService(
      String atSign, Function notificationCallBack, Function errorCallBack, Function retryCallBack) {
    if (_monitorService != null) return _monitorService;

    final preference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = '/commit/log/path'
      ..cramSecret = at_demo_data.cramKeyMap[atSign]
      ..namespace = AtConfig.namespace
      ..rootDomain = AtConfig.root
      ..hiveStoragePath = '/hive/storage/path'
      ..privateKey = at_demo_data.pkamPrivateKeyMap[atSign];

    var monitorPreference = MonitorPreference();
    monitorPreference.keepAlive = true;
    return _monitorService =
        Monitor(notificationCallBack, errorCallBack, atSign, preference, monitorPreference, retryCallBack);
  }

  Future<void> syncOnce(Function onSuccess) async {
    _atClientManager.syncService.sync(onDone: onSuccess);
  }

  ///notifies [receiverAtsign] with [value].
  Future<void> notify(String value, String receiverAtsign, {Function doneCallBack, Function errorCallBack}) async {
    try {
      var metadata = Metadata()
        ..ttr = 24 * 60 * 60 * 1000
        ..createdAt = DateTime.now();
      var inputValue = value;
      AtKey atKey = AtKey()
        ..key = 'sample'
        ..metadata = metadata
        ..sharedWith = receiverAtsign;
      await _atClientManager.notificationService.notify(NotificationParams.forUpdate(atKey, value: value),
          onSuccess: (value) {
        var notificationId = value.notificationID;
        this.sentNotificationsList.insert(
            0,
            AtNotification(
              id: notificationId,
              toAtSign: receiverAtsign,
              value: inputValue,
              dateTime: DateTime.now().millisecondsSinceEpoch,
              key: value.atKey.key,
              operation: 'Update',
              status: value.notificationStatusEnum.toString().split('.')[1],
            ));
        doneCallBack(value);
      }, onError: log);
      // await _atClientManager.atClient.notify(atKey, value, OperationEnum.update, , errorCallBack);
    } on Exception catch (e) {
      errorCallBack(e);
    }
  }

  //status of a notifications
  Future<void> notifyStatus(String notificationId, {Function doneCallBack, Function errorCallBack}) async {
    await _atClientManager.atClient.notifyStatus(notificationId);
  }

  //notifications list from past 1day will be fetched.
  Future<void> myNotifications() async {
    try {
      await this.sync((value) => print('sync success: $value'));
      var date = DateTime.now();
      date = date.subtract(Duration(days: 1));
      var response = await _atClientManager.atClient.notifyList(
        fromDate: date.toString(),
      );
      var parserResponse = DefaultResponseParser().parse(response);
      if (parserResponse.response == 'null' || parserResponse.response == null) {
        return [];
      }
      this.myNotificationsList =
          AtNotification.fromJsonList(List<Map<String, dynamic>>.from(jsonDecode(parserResponse.response)));
      //descending order
      this.myNotificationsList.sort((e1, e2) => e2.dateTime.compareTo(e1.dateTime));
    } catch (e) {
      _logger.severe('Fetching notification list throws $e');
    }
  }

  Future<void> sync(Function callBack) async {
    _atClientManager.syncService.sync(onDone: callBack);
  }

  Future<void> reset() async {
    await _keyChainManager.resetAtSignFromKeychain(atSign);
  }
}

class BackupKeyConstants {
  static const String AES_PKAM_PUBLIC_KEY = 'aesPkamPublicKey';
  static const String AES_PKAM_PRIVATE_KEY = 'aesPkamPrivateKey';
  static const String AES_ENCRYPTION_PUBLIC_KEY = 'aesEncryptPublicKey';
  static const String AES_ENCRYPTION_PRIVATE_KEY = 'aesEncryptPrivateKey';
}

class AtNotification {
  String id;
  String fromAtSign;
  String toAtSign;
  String key;
  String value;
  String operation;
  int dateTime;
  String status;

  AtNotification(
      {this.id, this.fromAtSign, this.toAtSign, this.key, this.value, this.dateTime, this.operation, this.status});

  factory AtNotification.fromJson(Map<String, dynamic> json) {
    return AtNotification(
      id: json['id'],
      fromAtSign: json['from'],
      dateTime: json['epochMillis'],
      toAtSign: json['to'],
      key: AtKey.fromString(json['key']).key,
      operation: json['operation'],
      value: json['value'],
    );
  }

  static List<AtNotification> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<AtNotification> notificationList = [];
    for (var json in jsonList) {
      notificationList.add(AtNotification.fromJson(json));
    }
    return notificationList;
  }
}
