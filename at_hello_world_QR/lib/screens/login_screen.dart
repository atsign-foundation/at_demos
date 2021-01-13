import 'dart:async';
import 'package:atsign_authentication_helper/screens/scan_qr.dart';
import 'package:flutter/material.dart';
import 'package:newserverdemo/screens/home_screen.dart';
import 'package:newserverdemo/services/server_demo_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _atsign;
  bool onboardSuccess = false;
  bool sharingStatus = false;
  ServerDemoService clientSdkService;
  final Permission _cameraPermission = Permission.camera;
  final Permission _storagePermission = Permission.storage;
  Completer c = Completer();
  bool authenticating = false;

  @override
  void initState() {
    super.initState();
    _initClientSdkService();
    _checkToOnboard();
    _checkForPermissionStatus();
    setAtSign();
  }

  void setAtSign() async {
    String atSign = await clientSdkService.getAtSign();
    setState(() {
      _atsign = atSign;
    });
  }

  String state;
  void _initClientSdkService() {
    clientSdkService = ServerDemoService.getInstance();
    clientSdkService.setNextScreen = HomeScreen();
  }

  void _checkToOnboard() async {
    // onboard call to get the already setup atsigns
    await clientSdkService.onboard().then((isChecked) async {
      if (!isChecked) {
        c.complete(true);
        print("onboard returned: $isChecked");
      } else {
        onboardSuccess = true;
        c.complete(true);
      }
    }).catchError((error) async {
      c.complete(true);
      print("Error in authenticating: $error");
    });
  }

  void _checkForPermissionStatus() async {
    final existingCameraStatus = await _cameraPermission.status;
    if (existingCameraStatus != PermissionStatus.granted) {
      await _cameraPermission.request();
    }
    final existingStorageStatus = await _storagePermission.status;
    if (existingStorageStatus != PermissionStatus.granted) {
      await _storagePermission.request();
    }
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
        inAsyncCall: authenticating,
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                width: 250,
                height: 250,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset(
                  "assets/atsign_logo.png",
                  ),
                ),
              ),
              Container(
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    _atsign != null ? "Welcome, " + _atsign : "Welcome",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Container(
                width: 500,
                height: 180,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20),
                      child: FlatButton(
                        minWidth: 200,
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
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    this.setState(() {
      authenticating = true;
    });
    await c.future;
    if (onboardSuccess) {
      await Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ScanQrScreen(
          atClientServiceInstance: clientSdkService.atClientServiceInstance,
          nextScreen: HomeScreen(),
        ),
        ),
      );
    }
  }
}
