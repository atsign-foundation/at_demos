import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget {
  static final String id = 'third';
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      // TODO: Fill in the body parameter of the Scaffold
      // All that is needed here is simply body: ChatScreen()
      // Anything added within the parameters of ChatScreen is simply
      // design features, some including:
      // final double height;
      // final bool isScreen;
      // final Color outgoingMessageColor;
      // final Color incomingMessageColor;
      // final Color senderAvatarColor;
      // final Color receiverAvatarColor;
      // final String title;
      // final String hintText;
      body: ChatScreen(
        height: MediaQuery.of(context).size.height,
        incomingMessageColor: Colors.blue[100],
        outgoingMessageColor: Colors.green[100],
        isScreen: true,
      ),
    );
  }
}
