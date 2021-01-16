import 'dart:ui';
import 'package:at_chat_flutter_example/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../service/client_sdk_service.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;


class FirstScreen extends StatefulWidget {
  static final String id = 'first';
  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  bool showSpinner = false;
  bool isEditing = false;
  String atSign = '';
  TextEditingController _loginTextFieldController = TextEditingController();
  ClientSdkService _serverDemoService = ClientSdkService.getInstance();

  String _validateString(String value) {
    value = value.trim();
    if (_loginTextFieldController.text != null) {
      if (value.isEmpty) {
        return '@sign can\'t be empty';
      } else if (value.trim().contains(' ')) {
        return '@sign can\'t contain a space';
      }
    }
    return null;
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
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
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
                            'assets/sbhacks_logo.png',
                            height: 50.0,
                            width: 50.0,
                          ),
                        ),
                        title: Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                          ),
                        ),
                        subtitle: TextField(
                          decoration: InputDecoration(
                            hintText: '\tEnter your @sign',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Text(
                                '@',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                ),
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            errorText: isEditing ? _validateString(atSign) : null,
                            errorStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.redAccent,
                            ),
                          ),
                          controller: _loginTextFieldController,
                          onChanged: (value) {
                            setState(() {
                              atSign = value;
                              isEditing = true;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: FlatButton(
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
              Marquee(
                child: Container(
                  width: 1000,
                  child: Image.asset(
                    'assets/sbhacks_cloud.png',
                    height: 125,
                  ),
                ),
                direction: Axis.horizontal,
                pauseDuration: Duration(seconds: 1),
                animationDuration: Duration(seconds: 5),
                directionMarguee: DirectionMarguee.oneDirection,
              ),
              Marquee(
                child: Container(
                  width: 1000,
                  child: Image.asset(
                    'assets/sbhacks_cloud.png',
                    height: 40,
                  ),
                ),
                direction: Axis.horizontal,
                pauseDuration: Duration(seconds: 2),
                animationDuration: Duration(seconds: 7),
                directionMarguee: DirectionMarguee.oneDirection,
                textDirection: TextDirection.rtl,
              ),
              Container(
                height: 200,
                child: FittedBox(
                  child: Image.asset(
                    'assets/sbhacks_island.png',
                  ),
                  fit: BoxFit.fitHeight,
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
  _login() async {
    FocusScope.of(context).unfocus();
    setState(() {
      showSpinner = true;
    });
    if (atSign != null) {
      atSign = '@' + atSign;
      String jsonData = _serverDemoService.encryptKeyPairs(atSign);
      _serverDemoService.onboard().then((value) {
        Navigator.pushReplacementNamed(context, SecondScreen.id);
      }).catchError((error) async {
        await _serverDemoService.authenticate(atSign,
            jsonData: jsonData, decryptKey: at_demo_data.aesKeyMap[atSign]);
        Navigator.pushReplacementNamed(context, SecondScreen.id);
      });
    }
  }
}
