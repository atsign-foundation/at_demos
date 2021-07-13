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
  // ClientSdkService clientSdkService = ClientSdkService.getInstance();
  var atClientPreference;
  var _logger = AtSignLogger('Plugin example app');
  @override
  void initState() {
    ClientSdkService.getInstance().onboard();
    ClientSdkService.getInstance()
        .getAtClientPreference()
        .then((value) => atClientPreference = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Home'),
        ),
        // appBar: AppBar(
        //   title: const Text('Plugin example app'),
        // ),
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                    onPressed: () async {
                      // TODO: Add in at_onboarding_flutter
                      Onboarding(
                        appAPIKey:'477b-876u-bcez-c42z-6a3d' ,
                        context: context,
                        atClientPreference: atClientPreference,
                        domain: MixedConstants.ROOT_DOMAIN,
                        appColor: Color.fromARGB(255, 240, 94, 62),
                        onboard: (value, atsign) {
                          ClientSdkService.getInstance().atClientServiceMap =
                              value;
                          ClientSdkService.getInstance()
                              .atClientServiceInstance = value[atsign];
                          _logger.finer('Successfully onboarded $atsign');
                        },
                        onError: (error) {
                          _logger.severe('Onboarding throws $error error');
                        },
                        nextScreen: SecondScreen(),
                      );
                    },
                    child: Text(AppStrings.scan_qr)),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    KeyChainManager _keyChainManager =
                        KeyChainManager.getInstance();
                    var _atSignsList =
                        await _keyChainManager.getAtSignListFromKeychain();
                    _atSignsList?.forEach((element) {
                      _keyChainManager.deleteAtSignFromKeychain(element);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Keychain cleaned',
                      textAlign: TextAlign.center,
                    )));
                  },
                  child: Text(
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
