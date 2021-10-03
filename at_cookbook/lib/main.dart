import 'package:chefcookbook/screens/add_dish_screen.dart';
import 'package:chefcookbook/screens/home_screen.dart';
import 'package:chefcookbook/screens/other_screen.dart';
import 'package:chefcookbook/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
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
        initialRoute: OnboardingScreen.id,
        routes: <String, Widget Function(BuildContext)>{
          OnboardingScreen.id: (BuildContext context) => OnboardingScreen(),
          HomeScreen.id: (BuildContext context) => HomeScreen(),
          DishScreen.id: (BuildContext context) => DishScreen(),
          OtherScreen.id: (BuildContext context) => OtherScreen(),
        });
  }
}
