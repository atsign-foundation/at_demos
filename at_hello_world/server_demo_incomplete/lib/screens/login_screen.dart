import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newserverdemo/screens/home_screen.dart';
import 'package:newserverdemo/services/server_demo_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String atSign;
  bool showSpinner = false;
  final ServerDemoService _serverDemoService = ServerDemoService.getInstance();

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
                width: 500,
                height: 220,
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
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: DropdownButton<String>(
                          hint: const Text('\tPick an @sign'),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepOrange,
                          ),
                          onChanged: (String newValue) {
                            setState(() => atSign = newValue);
                          },
                          value: atSign,
                          items: at_demo_data.allAtsigns
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: TextButton(
                          child: const Text('Login'),
                          onPressed: _login,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 280),
              Container(
                height: 50,
                child: FittedBox(
                  child: Image.asset('assets/@logo.png'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Write _login method
  /// Use onboard() to authenticate via PKAM public/private keys. If
  /// onboard() fails, use authenticate() to place keys.
  Future<void> _login() async {
    if (atSign != null) {
      FocusScope.of(context).unfocus();
      setState(() => showSpinner = true);
      String jsonData = _serverDemoService.encryptKeyPairs(atSign);
      await _serverDemoService.onboard(atsign: atSign).then((value) async {
        await Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: atSign);
      }).catchError((error) async {
        await _serverDemoService.authenticate(
          atSign,
          jsonData: jsonData,
          decryptKey: at_demo_data.aesKeyMap[atSign]
        );
        await Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: atSign);
      });
      // TODO: Complete the rest of the if statement!
    }
  }
}
