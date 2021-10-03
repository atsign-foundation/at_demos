// import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:at_client/src/service/notification_service.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
import '../utils/constants.dart' as conf;

class ClientSdkService {
  static final ClientSdkService _singleton = ClientSdkService._internal();

  ClientSdkService._internal();

  factory ClientSdkService.getInstance() {
    return _singleton;
  }

  AtClientService? atClientServiceInstance;
  final AtClientManager atClientInstance = AtClientManager.getInstance();
  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  Map<String?, AtClientService> atClientServiceMap = <String?, AtClientService>{};
  String? atsign;

  void _reset() {
    atClientServiceInstance = null;
    atClientServiceMap = <String?, AtClientService>{};
    atsign = null;
  }

  AtClient? _getAtClientForAtsign() {
    return atClientInstance.atClient;
  }

  Future<AtClientPreference> getAtClientPreference({String? cramSecret}) async {
    Directory appDocumentDirectory = await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    AtClientPreference _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = conf.MixedConstants.NAMESPACE
      ..rootDomain = conf.MixedConstants.ROOT_DOMAIN
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  Future<dynamic> get(AtKey atKey) async {
    AtValue result = await _getAtClientForAtsign()!.get(atKey);
    return result.value;
  }

  Future<bool> put(AtKey atKey, String value) async {
    return _getAtClientForAtsign()!.put(atKey, value);
  }

  Future<bool> delete(AtKey atKey) async {
    bool isDeleted = await _getAtClientForAtsign()!.delete(atKey);
    return isDeleted;
  }

  Future<List<AtKey>> getAtKeys(String regex, {String? sharedBy}) async {
    return _getAtClientForAtsign()!.getAtKeys(regex: conf.MixedConstants.NAMESPACE, sharedBy: sharedBy);
  }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return await _keyChainManager.getAtSign();
  }

  Future<void> deleteAtSignFromKeyChain() async {
    // List<String> atSignList = await getAtsignList();
    String? atsign = atClientInstance.atClient.getCurrentAtSign();

    await _keyChainManager.deleteAtSignFromKeychain(atsign!);

    _reset();
  }

  Future<bool> notify(AtKey atKey, String value, OperationEnum operation) async {
    try {
      if (operation == OperationEnum.update) {
        await atClientInstance.notificationService.notify(
          NotificationParams.forUpdate(
            atKey,
            value: value,
          ),
        );
        return true;
      }
      return true;
    } on AtClientException catch (e) {
      print('AtClientException : ${e.errorCode} - ${e.errorMessage}');
      return false;
    } catch (e) {
      print('Exception : $e');
      return false;
    }
  }
}
