import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newserverdemo/screens/home_screen.dart';
import 'package:newserverdemo/services/server_demo_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;

String atSign;

class LoginScreen extends StatefulWidget {
  static final String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TODO: Instantiate variables
  bool showSpinner = false;
  bool displayErrorMessage = false;
  String atSignInKeyChain = '';
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  Future<bool> checkIfCorrectAtSign() async {
    String currentAtSign = await _serverDemoService.getAtSign();
    if (currentAtSign.compareTo(atSign) == 0) {
      return true;
    }
    setState(() {
      atSignInKeyChain = currentAtSign;
    });
    return false;
  }

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
        // TODO: Assign boolean to inAsyncCall
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
                        leading: Icon(Icons.person_pin, size: 70),
                        title: Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        subtitle: DropdownButton<String>(
                          hint:  Text('\tPick an @sign'),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black87
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              atSign = newValue;
                            });
                          },
                          value: atSign != null ? atSign : null,
                          items: at_demo_data.allAtsigns
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      displayErrorMessage ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Error: Use @sign'
                              " stored in device's keychain: "
                              + atSignInKeyChain,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),
                      )
                      : Container(),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: FlatButton(
                          child: Text('Login'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          // TODO: Assign function to onPressed
                          onPressed: _login,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Write _login method
  /// Use onboard() to authenticate via PKAM public/private keys.
  _login() async {
    FocusScope.of(context).unfocus();
    setState(() {
      showSpinner = true;
    });

    String jsonData = _serverDemoService.encryptKeyPairs(atSign);
    if (atSign != null) {
      _serverDemoService.onboard().then((value) async {
        if (await checkIfCorrectAtSign()) {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        } else {
          setState(() {
            showSpinner = false;
            displayErrorMessage = true;
          });
        }
      }).catchError((error) async {
        await _serverDemoService.authenticate(atSign,
            jsonData: jsonData, decryptKey: at_demo_data.aesKeyMap[atSign]);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      });
    }
  }
}
