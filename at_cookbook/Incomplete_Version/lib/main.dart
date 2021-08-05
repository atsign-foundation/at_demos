import 'package:chefcookbook/screens/add_dish_screen.dart';
import 'package:chefcookbook/screens/home_screen.dart';
import 'package:chefcookbook/screens/other_screen.dart';
import 'package:chefcookbook/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0XFF7B3F00,
            <int, Color>{
              50: Color(0xff7b3f00),
              100: Color(0xff7b3f00),
              200: Color(0xff7b3f00),
              300: Color(0xff7b3f00),
              400: Color(0xff7b3f00),
              500: Color(0xff7b3f00),
              600: Color(0xff7b3f00),
              700: Color(0xff7b3f00),
              800: Color(0xff7b3f00),
              900: Color(0xff7b3f00),
            },
          ),
          scaffoldBackgroundColor: const Color(0xfff1ebe5),
          accentColor: const Color(0xff7b3f00),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          HomeScreen.id: (context) => const HomeScreen(shouldReload: false),
          DishScreen.id: (context) => DishScreen(),
          OtherScreen.id: (context) => OtherScreen(),
        });
  }
}
