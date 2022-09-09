import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_dude/commands/reset_command.dart';
import 'package:at_dude/models/contacts_model.dart';
import 'package:at_dude/services/services.dart';
import 'package:at_dude/utils/texts.dart';
import 'package:at_dude/views/screens/send_dude_screen.dart';
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'commands/onboard_command.dart';

final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

Future<void> main() async {
  // * AtEnv is an abtraction of the flutter_dotenv package used to
  // * load the environment variables set by at_app
  try {
    await AtEnv.load();
  } catch (e) {
    _logger.finer('Environment failed to load from .env: ', e);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (c) => AuthenticationService.getInstance()),
        ChangeNotifierProvider(create: (c) => ContactsModel()),
      ],
      child: MaterialApp(
        // * The onboarding screen (first screen)
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navKey,
        routes: {
          SendDudeScreen.routeName: ((context) => SendDudeScreen()),
        },
        home: Scaffold(
          appBar: AppBar(
            title: const Text(Texts.atDude),
          ),
          body: Builder(
            builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    iconSize: 200,
                    icon: Image.asset('assets/images/dude_logo.png'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await OnboardCommand().run();
                    },
                    child: const Text(Texts.onboardAtsign),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Or',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ]),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await ResetCommand().run();
                    },
                    child: Text(Texts.resetApp),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
