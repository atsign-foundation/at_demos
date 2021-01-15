import 'dart:convert';
import 'dart:core';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import '../utils/constants.dart' as cons;
import 'package:at_client/src/util/encryption_util.dart';

class ClientSdkService {
  static final ClientSdkService _singleton = ClientSdkService._internal();

  ClientSdkService._internal();

  factory ClientSdkService.getInstance() {
    return _singleton;
  }

  AtClientService atClientServiceInstance;
  AtClientImpl atClientInstance;

  Future<bool> onboard({String atsign}) async {
    atClientServiceInstance = AtClientService();
    final appDocumentDirectory =
    await path_provider.getApplicationDocumentsDirectory();
    String path = appDocumentDirectory.path;
    var atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = cons.MixedConstants.ROOT_DOMAIN
      ..hiveStoragePath = path;
    var result = await atClientServiceInstance.onboard(
        atClientPreference: atClientPreference,
        atsign: atsign,
        namespace: cons.MixedConstants.NAMESPACE);
    atClientInstance = atClientServiceInstance.atClient;
    return result;
  }

  ///Returns `false` if fails in authenticating [atsign] with [cramSecret]/[privateKey].
  Future<bool> authenticate(String atsign,
      {String cramSecret, String privateKey,String jsonData,
        String decryptKey,}) async {
    var result = await atClientServiceInstance.authenticate(atsign,
        cramSecret: cramSecret,jsonData: jsonData,decryptKey: decryptKey);
    atClientInstance = atClientServiceInstance.atClient;
    return result;
  }

  String encryptKeyPairs(String atsign)  {
    var encryptedPkamPublicKey =  EncryptionUtil.encryptValue(
        at_demo_data.pkamPublicKeyMap[atsign], at_demo_data.aesKeyMap[atsign]);
    var encryptedPkamPrivateKey =  EncryptionUtil.encryptValue(
        at_demo_data.pkamPrivateKeyMap[atsign], at_demo_data.aesKeyMap[atsign]);
    var aesencryptedPkamPublicKey =  EncryptionUtil.encryptValue(
        at_demo_data.encryptionPublicKeyMap[atsign],
        at_demo_data.aesKeyMap[atsign]);
    var aesencryptedPkamPrivateKey =  EncryptionUtil.encryptValue(
        at_demo_data.encryptionPrivateKeyMap[atsign],
        at_demo_data.aesKeyMap[atsign]);
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