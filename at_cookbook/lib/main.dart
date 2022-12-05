import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'home_screen.dart';
import 'package:at_cookbook_refactored/add_dish_screen.dart';
import 'package:at_cookbook_refactored/home_screen.dart';
import 'package:at_cookbook_refactored/other_screen.dart';
import 'package:at_cookbook_refactored/welcome_screen.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await getApplicationSupportDirectory();

  return AtClientPreference()
    ..rootDomain = AtEnv.rootDomain
    ..namespace = AtEnv.appNamespace
    ..hiveStoragePath = dir.path
    ..commitLogPath = dir.path
    ..isLocalStoreRequired = true;
  // TODO
  // * By default, this configuration is suitable for most applications
  // * In advanced cases you may need to modify [AtClientPreference]
  // * Read more here: https://pub.dev/documentation/at_client/latest/at_client/AtClientPreference-class.html
}

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'at_cookbook_refactored',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0XFF7B3F00,
          <int, Color>{
            50: Color(0XFF7B3F00),
            100: Color(0XFF7B3F00),
            200: Color(0XFF7B3F00),
            300: Color(0XFF7B3F00),
            400: Color(0XFF7B3F00),
            500: Color(0XFF7B3F00),
            600: Color(0XFF7B3F00),
            700: Color(0XFF7B3F00),
            800: Color(0XFF7B3F00),
            900: Color(0XFF7B3F00),
          },
        ),
        scaffoldBackgroundColor: const Color(0XFFF1EBE5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: WelcomeScreen.id,
      routes: <String, Widget Function(BuildContext)>{
        WelcomeScreen.id: (BuildContext context) => WelcomeScreen(),
        HomeScreen.id: (BuildContext context) => HomeScreen(),
        DishScreen.id: (BuildContext context) => DishScreen(),
        OtherScreen.id: (BuildContext context) => OtherScreen(),
      },
    );
  }
}
