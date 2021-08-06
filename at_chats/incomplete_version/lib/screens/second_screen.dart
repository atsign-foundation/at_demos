import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
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
  String? activeAtSign = '';
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<String>? atSigns;
  String? chatWithAtSign;
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
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                'Welcome $activeAtSign!',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text('Choose an @sign to chat with'),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: DropdownButton<String>(
                hint: const Text('\tPick an @sign'),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(fontSize: 20.0, color: Colors.black87),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: isEnabled
                    ? (String? newValue) {
                        setState(() {
                          chatWithAtSign = newValue;
                          isEnabled = false;
                        });
                      }
                    : null,
                disabledHint:
                    chatWithAtSign != null ? Text(chatWithAtSign!) : null,
                value: chatWithAtSign,
                items: atSigns == null
                    ? null
                    : atSigns!.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            showOptions
                ? Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () {
                          scaffoldKey!.currentState!.showBottomSheet(
                              (BuildContext context) => const ChatScreen());
                        },
                        child: Container(
                          height: 40,
                          child: const Text('Open chat in bottom sheet'),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, ThirdScreen.id);
                        },
                        child: Container(
                          height: 40,
                          child: const Text('Navigate to chat screen'),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          if (chatWithAtSign != null &&
                              chatWithAtSign!.trim() != '') {
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
                                      children: <Widget>[
                                        const Text('@sign Missing!')
                                      ],
                                    ),
                                    content:
                                        const Text('Please enter an @sign'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: Container(
                          height: 40,
                          child: const Text('Chat options'),
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
  Future<void> getAtSignAndInitializeChat() async {
    String? currentAtSign = await clientSdkService.getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
    List<String> allAtSigns = at_demo_data.allAtsigns;
    allAtSigns.remove(currentAtSign);
    setState(() {
      atSigns = allAtSigns;
    });
    initializeChatService(
        clientSdkService.atClientServiceInstance!.atClient!, currentAtSign!,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }

  // TODO: Write function that determines whom you are chatting with
  void setAtsignToChatWith() => setChatWithAtSign(chatWithAtSign);
}
