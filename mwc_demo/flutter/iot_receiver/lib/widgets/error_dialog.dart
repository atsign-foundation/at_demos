import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.title, this.message, this.actions, {Key? key})
      : super(key: key);

  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 280,
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions,
      ),
    );
  }
}