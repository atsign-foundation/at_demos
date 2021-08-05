// ignore_for_file: unused_element
import 'dart:core';
import 'dart:io';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
import '../utils/constants.dart' as conf;
import 'package:at_utils/at_logger.dart';

class ClientSdkService {
  final AtSignLogger _logger = AtSignLogger('Plugin example app');
  static final ClientSdkService _singleton = ClientSdkService._internal();

  ClientSdkService._internal();

  factory ClientSdkService.getInstance() {
    return _singleton;
  }

  AtClientService? atClientServiceInstance;
  AtClientImpl? atClientInstance;
  Map<String?, AtClientService> atClientServiceMap =
      <String?, AtClientService>{};
  String? atsign;

  void _reset() {
    atClientServiceInstance = null;
    atClientInstance = null;
    atClientServiceMap = <String?, AtClientService>{};
    atsign = null;
  }

  Future<void> _sync() async =>
      _getAtClientForAtsign()!.getSyncManager()!.sync();

  AtClientImpl? _getAtClientForAtsign({String? atsign}) {
    atsign ??= this.atsign;
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign]!.atClient;
    }
    return null;
  }

  AtClientService? _getClientServiceForAtSign(String atsign) {
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign];
    }
    return AtClientService();
  }

  Future<AtClientPreference> getAtClientPreference({String? cramSecret}) async {
    Directory appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    AtClientPreference _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = conf.MixedConstants.NAMESPACE
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = conf.MixedConstants.ROOT_DOMAIN
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  Future<ServerStatus?> _checkAtSignStatus(String atsign) async {
    AtStatusImpl atStatusImpl =
        AtStatusImpl(rootUrl: conf.MixedConstants.ROOT_DOMAIN);
    AtStatus status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  /// Gets [AtValue] and returns [AtValue.value].
  /// It may be null when it throws an exception.
  Future<String?> get(AtKey atKey) async {
    try {
      AtValue? result = await _getAtClientForAtsign()!.get(atKey);
      return result.value;
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.errorMessage}');
      return null;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return null;
    }
  }

  /// Creates or updates [AtKey.key] with it's
  /// [AtValue.value] and returns Future bool value.
  Future<bool> put(AtKey atKey, String value) async {
    try {
      return _getAtClientForAtsign()!.put(atKey, value);
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.errorMessage}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }

  /// Deletes [AtKey.atKey], so that it's values also
  /// will be deleted and returns Future bool value.
  Future<bool> delete(AtKey atKey) async {
    try {
      return _getAtClientForAtsign()!.delete(atKey);
    } on AtClientException catch (atClientExcep) {
      _logger.severe('❌ AtClientException : ${atClientExcep.errorMessage}');
      return false;
    } catch (e) {
      _logger.severe('❌ Exception : ${e.toString()}');
      return false;
    }
  }

  Future<List<AtKey>> getAtKeys({String? regex, String? sharedBy}) async =>
      _getAtClientForAtsign()!
          .getAtKeys(regex: conf.MixedConstants.NAMESPACE, sharedBy: sharedBy);

  /// Fetches atsign from device keychain.
  Future<String?> getAtSign() async => atClientServiceInstance!.getAtSign();

  Future<void> deleteAtSignFromKeyChain() async {
    // List<String> atSignList = await getAtsignList();
    String? atsign = atClientServiceInstance!.atClient!.currentAtSign;

    await atClientServiceMap[atsign]!.deleteAtSignFromKeychain(atsign!);

    _reset();
  }

  Future<bool> notify(
          AtKey atKey, String value, OperationEnum operation) async =>
      _getAtClientForAtsign()!.notify(atKey, value, operation);
}
