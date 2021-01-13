import 'dart:async';
import 'dart:io';
import 'package:atsign_authentication_helper/screens/private_key_qrcode_generator.dart';
import 'package:atsign_authentication_helper/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
import '../utils/at_conf.dart' as conf;

class ServerDemoService {
  static final ServerDemoService _singleton = ServerDemoService._internal();
  ServerDemoService._internal();

  factory ServerDemoService.getInstance() {
    return _singleton;
  }
  AtClientService atClientServiceInstance;
  AtClientImpl atClientInstance;
  String _atsign;
  Function ask_user_acceptance;
  String app_lifecycle_state;
  AtClientPreference atClientPreference;
  bool autoAcceptFiles = false;
  final String AUTH_SUCCESS = "Authentication successful";
  String get currentAtsign => _atsign;
  Directory downloadDirectory;

  Widget _nextScreen;
  set setNextScreen(Widget nextScreen) {
    _nextScreen = nextScreen;
  }

  Widget get nextScreen => _nextScreen;

  Future<bool> onboard({String atsign}) async {
    atClientServiceInstance = AtClientService();
    if (Platform.isIOS) {
      downloadDirectory =
      await path_provider.getApplicationDocumentsDirectory();
    } else {
      downloadDirectory = await path_provider.getExternalStorageDirectory();
    }

    final appSupportDirectory =
    await path_provider.getApplicationSupportDirectory();
    print("paths => $downloadDirectory $appSupportDirectory");
    String path = appSupportDirectory.path;
    atClientPreference = AtClientPreference();
    atClientPreference.isLocalStoreRequired = true;
    atClientPreference.commitLogPath = path;
    atClientPreference.syncStrategy = SyncStrategy.IMMEDIATE;
    atClientPreference.rootDomain = conf.root;
    atClientPreference.hiveStoragePath = path;
    atClientPreference.downloadPath = downloadDirectory.path;
    var result = await atClientServiceInstance.onboard(
        atClientPreference: atClientPreference, atsign: atsign);
    atClientInstance = atClientServiceInstance.atClient;
    return result;
  }

  Future authenticate(String qrCodeString, BuildContext context) async {
    Completer c = Completer();
    if (qrCodeString.contains('@')) {
      try {
        List<String> params = qrCodeString.split(':');
        if (params?.length == 2) {
          await authenticateWithCram(params[0], cramSecret: params[1]);
          _atsign = params[0];
          c.complete(AUTH_SUCCESS);
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PrivateKeyQRCodeGenScreen()
            ),
          );
        }
      } catch (e) {
        print("error here =>  ${e.toString()}");
        c.complete('Fail to Authenticate');
        print(e);
      }
    } else {
      // wrong bar code
      c.complete("incorrect QR code");
      print("incorrect QR code");
    }
    return c.future;
  }

  Future<bool> authenticateWithCram(String atsign, {String cramSecret}) async {
    var result = await atClientServiceInstance.authenticate(atsign,
        cramSecret: cramSecret);
    atClientInstance = await atClientServiceInstance.atClient;
    return result;
  }

  Future<String> getAtSign() async {
    return await atClientServiceInstance.getAtSign();
  }

  Future<String> get(AtKey atKey) async {
    var result = await atClientInstance.get(atKey);
    return result.value;
  }

  Future<bool> put(AtKey atKey, String value) async {
    return await this.atClientInstance.put(atKey, value);
  }

  Future<bool> delete(AtKey atKey) async {
    return await this.atClientInstance.delete(atKey);
  }

  Future<List<String>> getKeys({String sharedBy}) async {
    return await this
        .atClientInstance
        .getKeys(sharedBy: sharedBy);
  }

  Future<List<AtKey>> getAtKeys({String sharedBy}) async {
    return await this
        .atClientInstance
        .getAtKeys(sharedBy: sharedBy);
  }
}