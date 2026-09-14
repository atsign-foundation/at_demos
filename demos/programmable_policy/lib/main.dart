import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:programmable_policy/src/app/app.dart';
import 'package:programmable_policy/src/app/app_error.dart';

void main() async {
  try {
    log('starting the app');
    runApp(App());
  } catch (e, s) {
    runApp(AppError(e, stackTrace: s));
  }
}
