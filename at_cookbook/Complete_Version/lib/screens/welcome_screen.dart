import 'dart:ui';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../service/client_sdk_service.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static final String id = 'first';
  @override
  _OnboardingScreen createState() => _OnboardingScreen();
}

class _OnboardingScreen extends State<OnboardingScreen> {
  bool showSpinner = false;
  bool isOnboarding = true;
  String? atSign;
  // ClientSdkService clientSdkService = ClientSdkService.getInstance();
  AtClientPreference? atClientPreference;
  final AtSignLogger _logger = AtSignLogger('Plugin example app');
  @override
  void initState() {
    ClientSdkService.getInstance()
        .getAtClientPreference()
        .then((AtClientPreference value) => atClientPreference = value);
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
        body: Builder(
          builder: (BuildContext context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: TextButton(
                    onPressed: () async {
                      if (isOnboarding) {
                        setState(() => isOnboarding = false);
                        Onboarding(
                          appAPIKey: AppStrings.prodAPIKey,
                          context: context,
                          atClientPreference: atClientPreference!,
                          domain: MixedConstants.ROOT_DOMAIN,
                          appColor: const Color.fromARGB(255, 240, 94, 62),
                          onboard: (Map<String?, AtClientService> value,
                              String? atsign) {
                            ClientSdkService.getInstance().atsign = atsign;
                            ClientSdkService.getInstance().atClientServiceMap =
                                value;
                            ClientSdkService.getInstance()
                                .atClientServiceInstance = value[atsign];
                            _logger.finer('Successfully onboarded $atsign');
                          },
                          onError: (Object? error) {
                            _logger.severe('Onboarding throws $error error');
                          },
                          nextScreen: HomeScreen(),
                        );
                      }
                    },
                    child: const Text(AppStrings.scan_qr)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    KeyChainManager _keyChainManager =
                        KeyChainManager.getInstance();
                    List<String>? _atSignsList =
                        await _keyChainManager.getAtSignListFromKeychain();
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
                        await _keyChainManager
                            .deleteAtSignFromKeychain(element);
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
