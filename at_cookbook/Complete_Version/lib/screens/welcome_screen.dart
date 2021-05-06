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
    // If an atsign has been chosen to authenticate
    if (atSign != null) {
      // Re-running the build method
      FocusScope.of(context).unfocus();
      setState(() {
        // Shows the spinning icon until the atsign is successfully authenticated
        showSpinner = true;
      });

      // a json string necessary to authenticate for the first time
      // and key pairs are stored within this string
      String jsonData = _serverDemoService.encryptKeyPairs(atSign);

      // Utilizing the onboard method, passing in the atsign that has been
      // selected to authenticate
      _serverDemoService.onboard(atsign: atSign).then((value) async {
        // Push navigator to home screen and also preventing authenticated atsign
        // from returning to login screen
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }).catchError((error) async {
        // First time authenticating with atsign will throw
        // 'atsign not found' error
        // onboard method looks for cached keys within device.
        // Authenticate will embed the necessary keys within the key chain
        await _serverDemoService.authenticate(atSign,
            // Passing the key pairs retrieved earlier in addition to the decrypt
            // key which is retireved from the at_demo_data file's list of
            // keys
            jsonData: jsonData,
            decryptKey: at_demo_data.aesKeyMap[atSign]);

        // Push navigator to home screen and also preventing authenticated atsign
        // from returning to login screen
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      });
    }
  }
}
