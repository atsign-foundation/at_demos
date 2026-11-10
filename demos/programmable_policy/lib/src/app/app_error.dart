import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppError extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;
  const AppError(this.error, {this.stackTrace, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        onPressed: () async {
          await SystemNavigator.pop();
          exit(1);
        },
        child: Text("Close"),
      ),
      Text(
        "Error starting the app: ${error.toString()}",
      ),
      if (stackTrace != null) Text("Stack Trace: ${stackTrace.toString()}"),
    ]);
  }
}
