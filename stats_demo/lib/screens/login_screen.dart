import 'dart:ui';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_onboarding_flutter/screens/onboarding_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:verbs_testing/services/server_demo_service.dart';
import 'package:verbs_testing/utils/at_conf.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String atSign;
  bool showSpinner = false;
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
              SizedBox(
                height: 20,
              ),
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
                        ),
                        title: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: DropdownButton<String>(
                          hint: Text('\tPick an @sign'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.blueAccent,
                          ),
                          onChanged: (String newValue) async {
                            setState(() {
                              showSpinner = true;
                              atSign = newValue;
                            });
                            await _serverDemoService.storeDemoDataToKeychain(newValue);
                            setState(() {
                              showSpinner = false;
                            });
                          },
                          value: atSign,
                          //!= null ? atSign : null,
                          items: at_demo_data.allAtsigns.map<DropdownMenuItem<String>>(
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
                        margin: EdgeInsets.all(20),
                        child: MaterialButton(
                          child: Text('Login'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: _login,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 280),
              Container(
                height: 50,
              ),
              // ElevatedButton(onPressed: () {}, child: Text('Reset'))
            ],
          ),
        ),
      ),
    );
  }

  /// Use onboard() to authenticate via PKAM public/private keys. If
  /// onboard() fails, use authenticate() to place keys.
  _login() async {
    if (atSign != null) {
      FocusScope.of(context).unfocus();
      return Onboarding(
        context: context,
        atClientPreference: await _serverDemoService.getAtClientPreference(atSign),
        atsign: atSign,
        domain: AtConfig.root,
        appColor: Color.fromARGB(255, 43, 155, 219),
        onboard: (atClientServiceMap, atsign) async {
          _serverDemoService.atClientServiceMap = atClientServiceMap;
          _serverDemoService.atSign = atsign;
          await _serverDemoService.persistKeys(atsign);
        },
        rootEnvironment: RootEnvironment.Testing,
        onError: (error) {
          print(error);
        },
        nextScreen: HomeScreen(atSign: atSign),
      );
    }
  }
}
