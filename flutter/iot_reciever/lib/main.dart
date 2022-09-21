import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:iot_reciever/screens/receivers_screen.dart';
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:flutter/material.dart';
import 'package:iot_reciever/models/iot_model.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

import 'package:iot_reciever/screens/home_screen.dart';
import 'package:iot_reciever/screens/onboarding_screen.dart';

final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

Future<void> main() async {
  // * AtEnv is an abtraction of the flutter_dotenv package used to
  // * load the environment variables set by at_app
  try {
    await AtEnv.load();
  } catch (e) {
    _logger.finer('Environment failed to load from .env: ', e);
  }

  AtSignLogger.root_level = 'INFO';

  runApp(const MyApp());
}

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await getApplicationSupportDirectory();

  return AtClientPreference()
    ..rootDomain = AtEnv.rootDomain
    ..namespace = AtEnv.appNamespace
    ..hiveStoragePath = dir.path
    ..commitLogPath = dir.path
    ..isLocalStoreRequired = true
    ..fetchOfflineNotifications = false;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // * load the AtClientPreference in the background
  IoT ioT = IoT(
      bloodOxygen: '0',
      heartRate: '0',
      sensorName: '@ZARIOT',
      heartTime: DateTime.now().toString(),
      oxygenTime: DateTime.now().toString());
  Future<AtClientPreference> futurePreference = loadAtClientPreference();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      debugShowCheckedModeBanner: false,
      title: 'HRO2 DISPLAY',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue)
            .copyWith(background: Colors.white),
      ),
      // * The onboarding screen (first screen)
      routes: {
        HomeScreen.id: (_) => HomeScreen(ioT: ioT),
        OnboardingScreen.id: (_) => const OnboardingScreen(),
        ReceiversScreen.id: (_) => const ReceiversScreen()
        //Next.id: (_) => const Next(),
      },
      initialRoute: OnboardingScreen.id,
    );
  }
}
