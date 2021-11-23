import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:verbs_testing/screens/home_screen.dart';
import 'package:at_utils/at_logger.dart';
import 'package:verbs_testing/screens/login_screen.dart';

void main() {
  AtSignLogger.root_level = 'finer';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '@Protocol Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.id,
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case HomeScreen.id:
            final atSign = setting.arguments;
            return MaterialPageRoute(
              builder: (_) => HomeScreen(atSign: atSign),
            );
          case LoginScreen.id:
          default:
            return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      },
    );
  }
}
