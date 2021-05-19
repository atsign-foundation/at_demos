import 'dart:core';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:newserverdemo/utils/at_conf.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;

class ServerDemoService {
  static final ServerDemoService _singleton = ServerDemoService._internal();

  ServerDemoService._internal();

  factory ServerDemoService.getInstance() => _singleton;

  AtClientService atClientServiceInstance;
  AtClientImpl atClientInstance;
  Map<String, AtClientService> atClientServiceMap = {};
  String atSign;

  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();

  sync() async => await getAtClientForAtsign().getSyncManager().sync();

  AtClientImpl getAtClientForAtsign({String atsign}) {
    atsign ??= atSign;
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign].atClient;
    }
    return null;
  }

  AtClientService getClientServiceForAtSign(String atsign) {
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign];
    }
    final service = AtClientService();
    return service;
  }

  Future<AtClientPreference> getAtClientPreference({String cramSecret}) async {
    final appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    final path = appDocumentDirectory.path;
    final _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = AtConfig.namespace
      ..syncStrategy = SyncStrategy.IMMEDIATE
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
    await _keyChainManager.storeCredentialToKeychain(atsign,
        privateKey: pkamPrivateKey, publicKey: pkamPublicKey);

    var encryptionPublicKey = at_demo_data.encryptionPublicKeyMap[atsign];
    await _keyChainManager.putValue(
        atsign, KEYCHAIN_ENCRYPTION_PUBLIC_KEY, encryptionPublicKey);

    var encryptionPrivateKey = at_demo_data.encryptionPrivateKeyMap[atsign];
    await _keyChainManager.putValue(
        atsign, KEYCHAIN_ENCRYPTION_PRIVATE_KEY, encryptionPrivateKey);
    await _keyChainManager.putValue(
        atsign, KEYCHAIN_SELF_ENCRYPTION_KEY, decryptKey);
  }

  Future<String> get(AtKey atKey) async {
    final result = await getAtClientForAtsign().get(atKey);
    return result.value;
  }

  Future<bool> put(AtKey atKey, String value) async =>
      await getAtClientForAtsign().put(atKey, value);

  Future<bool> delete(AtKey atKey) async =>
      await getAtClientForAtsign().delete(atKey);

  Future<List<AtKey>> getAtKeys({String sharedBy}) async =>
      await getAtClientForAtsign().getAtKeys(
        regex: AtConfig.namespace,
        sharedBy: sharedBy,
      );

  ///Fetches atsign from device keychain.
  Future<String> getAtSign() async {
    return await atClientServiceInstance.getAtSign();
  }
}

class BackupKeyConstants {
  static const String AES_PKAM_PUBLIC_KEY = 'aesPkamPublicKey';
  static const String AES_PKAM_PRIVATE_KEY = 'aesPkamPrivateKey';
  static const String AES_ENCRYPTION_PUBLIC_KEY = 'aesEncryptPublicKey';
  static const String AES_ENCRYPTION_PRIVATE_KEY = 'aesEncryptPrivateKey';
}
