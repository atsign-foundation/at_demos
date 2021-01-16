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
  bool displayErrorMessage = false;
  String atSign;
  String atSignInKeyChain = '';
  ClientSdkService clientSdkService = ClientSdkService.getInstance();

  Future<bool> checkIfCorrectAtSign() async {
    String currentAtSign = await clientSdkService.getAtSign();
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
        inAsyncCall: false,
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
                          value: atSign != null ? atSign
                              : null,
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
      // TODO: Complete the rest of the if statement!
      
    }
  }
}
