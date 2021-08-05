import 'dart:ui';
import 'package:at_chat_flutter_example/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../service/client_sdk_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;

class FirstScreen extends StatefulWidget {
  static final String id = 'first';
  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  bool showSpinner = false;
  String? atSign;
  ClientSdkService clientSdkService = ClientSdkService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: 220,
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/atsign.png',
                            height: 50.0,
                            width: 50.0,
                          ),
                        ),
                        title: const Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        subtitle: DropdownButton<String>(
                          hint: const Text('\tPick an @sign'),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black87),
                          underline: Container(
                            height: 2,
                            color: Colors.deepOrange,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              atSign = newValue;
                            });
                          },
                          value: atSign,
                          items: at_demo_data.allAtsigns
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: TextButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: _login,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 280,
              ),
              Container(
                height: 50,
                child: FittedBox(
                  child: Image.asset(
                    'assets/@logo.png',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Write _login method
  /// Use onboard() to authenticate via PKAM public/private keys.
  Future<void> _login() async {
    if (atSign != null) {
      FocusScope.of(context).unfocus();
      setState(() {
        showSpinner = true;
      });
      String jsonData = clientSdkService.encryptKeyPairs(atSign!);
      clientSdkService.onboard(atsign: atSign).then((bool value) async {
        Navigator.pushReplacementNamed(context, SecondScreen.id);
      }).catchError((Object? error) async {
        await clientSdkService.authenticate(atSign,
            jsonData: jsonData, decryptKey: at_demo_data.aesKeyMap[atSign]);
        Navigator.pushReplacementNamed(context, SecondScreen.id);
      });
      // TODO: Complete the rest of the if statement!
    }
  }
}
