import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:chefcookbook/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'home_screen.dart';

String atSign;

class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showSpinner = false;
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Chef\'s',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF956532),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                width: 90,
                                child: Hero(
                                  tag: 'chef',
                                  child: Image.asset(
                                    'assets/chef.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Cookbook',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF956532),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Center(
                            child: DropdownButton<String>(
                              hint: Text('\tPick an @sign'),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconSize: 24,
                              dropdownColor: Color(0XFFF1EBE5),
                              elevation: 16,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black87),
                              onChanged: (String newValue) {
                                setState(() {
                                  atSign = newValue;
                                });
                              },
                              value: atSign != null ? atSign : null,
                              items: at_demo_data.allAtsigns
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: RoundedButton(
                        text: 'Login',
                        path: _login,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: Image.asset(
                      'assets/@logo.png',
                      height: 30,
                    )),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  /// Authenticate into one of the testable @signs.
  _login() async {
    if (atSign != null) {
      FocusScope.of(context).unfocus();
      setState(() {
        showSpinner = true;
      });
      String jsonData = _serverDemoService.encryptKeyPairs(atSign);
      _serverDemoService.onboard(atsign: atSign).then((value) async {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }).catchError((error) async {
        await _serverDemoService.authenticate(atSign,
            jsonData: jsonData, decryptKey: at_demo_data.aesKeyMap[atSign]);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      });
    }
  }
}
