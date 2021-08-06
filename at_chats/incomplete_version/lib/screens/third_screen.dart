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
      appBar: AppBar(title: const Text('Chat')),
      // TODO: Fill in the body parameter of the Scaffold
      body: const ChatScreen()
    );
  }
}
