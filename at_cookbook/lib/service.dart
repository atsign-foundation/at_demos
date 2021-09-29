import 'dart:convert';
import 'dart:core';
import 'dart:io';
// ignore: implementation_imports
import 'package:at_client/src/util/encryption_util.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:at_server_status/at_server_status.dart';
import 'package:chefcookbook/constants.dart' as conf;
import 'package:chefcookbook/utils/constants.dart' as constants;
import 'package:path_provider/path_provider.dart' as path_provider;

class ServerDemoService {
  static final ServerDemoService _singleton = ServerDemoService._internal();

  ServerDemoService._internal();

  factory ServerDemoService.getInstance() {
    return _singleton;
  }

  AtClientService? atClientServiceInstance;
  final atClientInstance = AtClientManager.getInstance();
  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  Map<String?, AtClientService> atClientServiceMap = <String?, AtClientService>{};
  String? _atsign;

  Future<void> sync() async => atClientInstance.syncService.sync();

  AtClient _getAtClientForAtsign() {
    return atClientInstance.atClient;
  }

  AtClientService? _getClientServiceForAtSign(String? atsign) {
    if (atsign == null) {}
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign];
    }
    AtClientService service = AtClientService();
    return service;
  }

  Future<AtClientPreference> _getAtClientPreference({String? cramSecret}) async {
    Directory appDocumentDirectory = await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    AtClientPreference _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = conf.namespace
      ..rootDomain = conf.root
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  Future<ServerStatus?> _checkAtSignStatus(String atsign) async {
    AtStatusImpl atStatusImpl = AtStatusImpl(rootUrl: conf.root);
    AtStatus status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  Future<bool> onboard({String? atsign}) async {
    atClientServiceInstance = _getClientServiceForAtSign(atsign!);
    AtClientPreference atClientPreference = await _getAtClientPreference();
    bool result = await atClientServiceInstance!.onboard(atClientPreference: atClientPreference, atsign: atsign);
    _atsign = await getAtSign() ?? atsign;
    atClientServiceMap.putIfAbsent(_atsign, () => atClientServiceInstance!);
    await sync();
    return result;
  }

  ///Returns `false` if fails in authenticating [atsign] with [cramSecret]/[privateKey].
  Future<bool> authenticate(
    String atsign, {
    String? privateKey,
    String? jsonData,
    String? decryptKey,
  }) async {
    ServerStatus? atsignStatus = await _checkAtSignStatus(atsign);
    if (atsignStatus != ServerStatus.teapot && atsignStatus != ServerStatus.activated) {
      throw atsignStatus!;
    }
    AtClientPreference atClientPreference = await _getAtClientPreference();
    bool result = await atClientServiceInstance!
        .authenticate(atsign, atClientPreference, jsonData: jsonData, decryptKey: decryptKey);
    _atsign = atsign;
    atClientServiceMap.putIfAbsent(_atsign, () => atClientServiceInstance!);
    await sync();
    return result;
  }

  String encryptKeyPairs(String atsign) {
    String encryptedPkamPublicKey =
        EncryptionUtil.encryptValue(at_demo_data.pkamPublicKeyMap[atsign]!, at_demo_data.aesKeyMap[atsign]!);
    String encryptedPkamPrivateKey =
        EncryptionUtil.encryptValue(at_demo_data.pkamPrivateKeyMap[atsign]!, at_demo_data.aesKeyMap[atsign]!);
    String aesencryptedPkamPublicKey =
        EncryptionUtil.encryptValue(at_demo_data.encryptionPublicKeyMap[atsign]!, at_demo_data.aesKeyMap[atsign]!);
    String aesencryptedPkamPrivateKey =
        EncryptionUtil.encryptValue(at_demo_data.encryptionPrivateKeyMap[atsign]!, at_demo_data.aesKeyMap[atsign]!);
    Map<String, String> aesEncryptedKeys = <String, String>{};
    aesEncryptedKeys[constants.BackupKeyConstants.AES_PKAM_PUBLIC_KEY] = encryptedPkamPublicKey;

    aesEncryptedKeys[constants.BackupKeyConstants.AES_PKAM_PRIVATE_KEY] = encryptedPkamPrivateKey;

    aesEncryptedKeys[constants.BackupKeyConstants.AES_ENCRYPTION_PUBLIC_KEY] = aesencryptedPkamPublicKey;

    aesEncryptedKeys[constants.BackupKeyConstants.AES_ENCRYPTION_PRIVATE_KEY] = aesencryptedPkamPrivateKey;

    String keyString = jsonEncode(Map<String, String>.from(aesEncryptedKeys));
    return keyString;
  }

  Future<String> get(AtKey atKey) async {
    AtValue result = await _getAtClientForAtsign().get(atKey);
    return result.value;
  }

  Future<bool> put(AtKey atKey, String value) async {
    return _getAtClientForAtsign().put(atKey, value);
  }

  Future<bool> delete(AtKey atKey) async {
    return _getAtClientForAtsign().delete(atKey);
  }

  Future<List<AtKey>> getAtKeys({String? regex, String? sharedBy}) async {
    regex ??= conf.namespace;
    return _getAtClientForAtsign().getAtKeys(regex: regex, sharedBy: sharedBy);
  }

  Future<bool> notify(AtKey atKey, String value, OperationEnum operation) async {
    return _getAtClientForAtsign().notify(atKey, value, operation);
  }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return await _keyChainManager.getAtSign();
  }
}
