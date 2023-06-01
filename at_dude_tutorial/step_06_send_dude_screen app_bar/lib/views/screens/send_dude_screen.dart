import 'package:flutter/material.dart';

import '../../utils/texts.dart';
import '../widgets/atsign_avatar.dart';

class SendDudeScreen extends StatefulWidget {
  SendDudeScreen({Key? key}) : super(key: key);
  static String routeName = 'sendDudeScreen';

  @override
  State<SendDudeScreen> createState() => _SendDudeScreenState();
}

class _SendDudeScreenState extends State<SendDudeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          Texts.sendDude,
          style: TextStyle(color: Colors.black),
        ),
        actions: const [AtsignAvatar()],
      ),
    );
  }
}
