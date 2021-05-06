import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
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
  String activeAtSign = '';
  GlobalKey<ScaffoldState> scaffoldKey;
  List<String> atSigns;
  String chatWithAtSign;
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
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
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
            Text('Choose an @sign to chat with'),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: DropdownButton<String>(
                hint: Text('\tPick an @sign'),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                ),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(fontSize: 20.0, color: Colors.black87),
                underline: Container(
                  height: 2,
                  color: Colors.deepOrange,
                ),
                onChanged: isEnabled
                    ? (String newValue) {
                        setState(() {
                          chatWithAtSign = newValue;
                          isEnabled = false;
                        });
                      }
                    : null,
                disabledHint:
                    chatWithAtSign != null ? Text(chatWithAtSign) : null,
                value: chatWithAtSign != null ? chatWithAtSign : null,
                items: atSigns == null
                    ? null
                    : atSigns.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            showOptions
                ? Column(
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
      ),
    );
  }

  // TODO: Write function to initialize the chatting service
  getAtSignAndInitializeChat() async {
    // Initializing a string as the currently authenticated atsign
    // utilizing the clientSdkService file's getAtSign() method
    String currentAtSign = await clientSdkService.getAtSign();
    setState(() {
      // Re-running the build method to set the active atsign as
      // the atsign currently authenticated
      activeAtSign = currentAtSign;
    });

    // Initializing a list of strings that is populated with all of the
    // testable atsigns that exist within the at_demo_data file
    List<String> allAtSigns = at_demo_data.allAtsigns;

    // This will remove the atsign that is currently authenticated
    // from the list of atsigns as choosing your own atsign to chat
    // with will result in an error
    allAtSigns.remove(activeAtSign);
    setState(() {
      // Re-running the build method to set list of atsigns as
      // the previously initialized item list
      atSigns = allAtSigns;
    });

    // Initializing the chat service passing the parameters of the atClient,
    // the authenticated atsign and the root domain of the application
    initializeChatService(
        clientSdkService.atClientServiceInstance.atClient, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }

  // TODO: Write function that determines whom you are chatting with
  setAtsignToChatWith() {
    //Simply get which testable atsign the authenticated atsign wishes
    // to chat with
    setChatWithAtSign(chatWithAtSign);
  }
}
