import 'dart:convert';
import 'dart:core';
import 'package:at_client/src/util/encryption_util.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:at_server_status/at_server_status.dart';
import 'package:chefcookbook/constants.dart' as conf;
import 'package:path_provider/path_provider.dart' as path_provider;

class ServerDemoService {
  static final ServerDemoService _singleton = ServerDemoService._internal();

  ServerDemoService._internal();

  factory ServerDemoService.getInstance() {
    return _singleton;
  }

  AtClientService? atClientServiceInstance;
  AtClientImpl? atClientInstance;
  Map<String?, AtClientService> atClientServiceMap = {};
  String? _atsign;

  sync() async {
    await _getAtClientForAtsign()!.getSyncManager()!.sync();
  }

  AtClientImpl? _getAtClientForAtsign({String? atsign}) {
    atsign ??= _atsign;
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign]!.atClient;
    }
    return null;
  }

  AtClientService? _getClientServiceForAtSign(String atsign) {
    if (atsign == null) {}
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign];
    }
    var service = AtClientService();
    return service;
  }

  Future<AtClientPreference> _getAtClientPreference(
      {String? cramSecret}) async {
    final appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    var _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = conf.namespace
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = conf.root
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  _checkAtSignStatus(String atsign) async {
    var atStatusImpl = AtStatusImpl(rootUrl: conf.root);
    var status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  Future<bool> onboard({String? atsign}) async {
    atClientServiceInstance = _getClientServiceForAtSign(atsign!);
    var atClientPreference = await _getAtClientPreference();
    var result = await atClientServiceInstance!
        .onboard(atClientPreference: atClientPreference, atsign: atsign);
    _atsign = (atsign == null ? await this.getAtSign() : atsign)!;
    atClientServiceMap.putIfAbsent(_atsign, () => atClientServiceInstance!);
    sync();
    return result;
  }

  ///Returns `false` if fails in authenticating [atsign] with [cramSecret]/[privateKey].
  Future<bool> authenticate(
    String atsign, {
    String? privateKey,
    String? jsonData,
    String? decryptKey,
  }) async {
    var atsignStatus = await _checkAtSignStatus(atsign);
    if (atsignStatus != ServerStatus.teapot &&
        atsignStatus != ServerStatus.activated) {
      throw atsignStatus;
    }
    var atClientPreference = await _getAtClientPreference();
    var result = await atClientServiceInstance!.authenticate(
        atsign, atClientPreference,
        jsonData: jsonData, decryptKey: decryptKey);
    _atsign = atsign;
    atClientServiceMap.putIfAbsent(_atsign, () => atClientServiceInstance!);
    await sync();
    return result;
  }

  String encryptKeyPairs(String atsign) {
    var encryptedPkamPublicKey = EncryptionUtil.encryptValue(
        at_demo_data.pkamPublicKeyMap[atsign]!,
        at_demo_data.aesKeyMap[atsign]!);
    var encryptedPkamPrivateKey = EncryptionUtil.encryptValue(
        at_demo_data.pkamPrivateKeyMap[atsign]!,
        at_demo_data.aesKeyMap[atsign]!);
    var aesencryptedPkamPublicKey = EncryptionUtil.encryptValue(
        at_demo_data.encryptionPublicKeyMap[atsign]!,
        at_demo_data.aesKeyMap[atsign]!);
    var aesencryptedPkamPrivateKey = EncryptionUtil.encryptValue(
        at_demo_data.encryptionPrivateKeyMap[atsign]!,
        at_demo_data.aesKeyMap[atsign]!);
    var aesEncryptedKeys = {};
    aesEncryptedKeys[BackupKeyConstants.AES_PKAM_PUBLIC_KEY] =
        encryptedPkamPublicKey;

    aesEncryptedKeys[BackupKeyConstants.AES_PKAM_PRIVATE_KEY] =
        encryptedPkamPrivateKey;

    aesEncryptedKeys[BackupKeyConstants.AES_ENCRYPTION_PUBLIC_KEY] =
        aesencryptedPkamPublicKey;

    aesEncryptedKeys[BackupKeyConstants.AES_ENCRYPTION_PRIVATE_KEY] =
        aesencryptedPkamPrivateKey;

    var keyString = jsonEncode(Map<String, String>.from(aesEncryptedKeys));
    return keyString;
  }

  Future<String> get(AtKey atKey) async {
    var result = await _getAtClientForAtsign()!.get(atKey);
    return result.value;
  }

  Future<bool> put(AtKey atKey, String value) async {
    return await _getAtClientForAtsign()!.put(atKey, value);
  }

  Future<bool> delete(AtKey atKey) async {
    return await _getAtClientForAtsign()!.delete(atKey);
  }

  Future<List<AtKey>> getAtKeys({String? regex, String? sharedBy}) async {
    regex ??= conf.namespace;
    return await _getAtClientForAtsign()!
        .getAtKeys(regex: regex, sharedBy: sharedBy);
  }

  Future<bool> notify(
      AtKey atKey, String value, OperationEnum operation) async {
    return await _getAtClientForAtsign()!.notify(atKey, value, operation);
  }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return await atClientServiceInstance!.getAtSign();
  }
}

class BackupKeyConstants {
  static const String AES_PKAM_PUBLIC_KEY = 'aesPkamPublicKey';
  static const String AES_PKAM_PRIVATE_KEY = 'aesPkamPrivateKey';
  static const String AES_ENCRYPTION_PUBLIC_KEY = 'aesEncryptPublicKey';
  static const String AES_ENCRYPTION_PRIVATE_KEY = 'aesEncryptPrivateKey';
}
