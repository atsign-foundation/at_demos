import 'dart:ui';
import 'package:at_chat_flutter_example/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/widgets.dart';
import '../service/client_sdk_service.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import '../utils/constants.dart';
import 'second_screen.dart';

class FirstScreen extends StatefulWidget {
  static final String id = 'first';
  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  bool showSpinner = false;
  String? atSign;
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  AtClientPreference? atClientPreference;
  final AtSignLogger _logger = AtSignLogger('Plugin example app');
  Future<void> _getAtClientPreference() async {
    atClientPreference = await clientSdkService.getAtClientPreference();
  }

  @override
  void initState() {
    _getAtClientPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text('Home'),
        ),
        // appBar: AppBar(
        //   title: const Text('Plugin example app'),
        // ),
        body: Builder(
          builder: (BuildContext context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () async {
                    Onboarding(
                      appAPIKey: AppStrings.prodAPIKey,
                      context: context,
                      atClientPreference: atClientPreference!,
                      domain: MixedConstants.ROOT_DOMAIN,
                      appColor: const Color.fromARGB(255, 240, 94, 62),
                      onboard: (Map<String?, AtClientService> value, String? atsign) {
                        clientSdkService.atClientServiceMap = value;
                        clientSdkService.atClientServiceInstance = value[atsign];
                        _logger.finer('Successfully onboarded $atsign');
                      },
                      onError: (Object? error) {
                        _logger.severe('Onboarding throws ${error.toString()} error');
                      },
                      nextScreen: SecondScreen(), rootEnvironment: RootEnvironment.Production,
                    );
                  },
                  child: const Text(AppStrings.scan_qr),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    KeyChainManager _keyChainManager = KeyChainManager.getInstance();
                    List<String>? _atSignsList = await _keyChainManager.getAtSignListFromKeychain();
                    if (_atSignsList == null || _atSignsList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '@sign list is empty.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      for (String element in _atSignsList) {
                        await _keyChainManager.deleteAtSignFromKeychain(element);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Keychain cleaned',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    AppStrings.reset_keychain,
                    style: TextStyle(color: Colors.blueGrey),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
