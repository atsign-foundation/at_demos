import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
import '../service/client_sdk_service.dart';
import 'third_screen.dart';
import '../utils/constants.dart';

class SecondScreen extends StatefulWidget {
  static final String id = 'second';
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String activeAtSign;
  GlobalKey<ScaffoldState> scaffoldKey;
  String chatWithAtSign = '';
  bool showOptions = false;
  bool isEnabled = true;

  @override
  void initState() {
    // TODO: Call function to initialize chat service.
    getAtSignAndInitializeChat();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Second Screen')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              'Welcome $activeAtSign!',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text('Enter an @sign to chat with'),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextFormField(
              enabled: isEnabled,
              autofocus: true,
              onChanged: (value) {
                chatWithAtSign = value;
              },
              onEditingComplete: () {
                setState(() {
                  isEnabled = false;
                });
              },
              decoration: InputDecoration(
                prefixText: '@',
                prefixStyle: TextStyle(color: Colors.grey),
                hintText: '\tEnter user @sign',
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          showOptions ? Column(
            children: [
              SizedBox(height: 20.0),
              FlatButton(
                onPressed: () {
                  scaffoldKey.currentState
                      .showBottomSheet((context) => ChatScreen());
                },
                child: Container(
                  height: 40,
                  child: Text('Open chat in bottom sheet'),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, ThirdScreen.id);
                },
                child: Container(
                  height: 40,
                  child: Text('Navigate to chat screen'),
                ),
              )
            ],
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () {
                  if (chatWithAtSign != null &&
                      chatWithAtSign.trim() != '') {
                    // TODO: Call function to set receiver's @sign
                    setAtsignToChatWith();
                    setState(() {
                      showOptions = true;
                    });
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [Text('@sign Missing!')],
                          ),
                          content: Text('Please enter an @sign'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            )
                          ],
                        );
                      });
                    }
                },
                child: Container(
                  height: 40,
                  child: Text('Chat options'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // TODO: Write function to initialize the chatting service
  getAtSignAndInitializeChat() async {
    String currentAtSign = await clientSdkService.getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
    initializeChatService(
        clientSdkService.atClientServiceInstance.atClient, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }
  // TODO: Write function that determines whom you are chatting with
  setAtsignToChatWith() {
    setChatWithAtSign(chatWithAtSign);
  }
}
