import 'package:chefcookbook/screens/add_dish_screen.dart';
import 'package:chefcookbook/screens/home_screen.dart';
import 'package:chefcookbook/screens/other_screen.dart';
import 'package:chefcookbook/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: MaterialColor(
            0XFF7B3F00,
            const <int, Color>{
              50: const Color(0XFF7B3F00),
              100: const Color(0XFF7B3F00),
              200: const Color(0XFF7B3F00),
              300: const Color(0XFF7B3F00),
              400: const Color(0XFF7B3F00),
              500: const Color(0XFF7B3F00),
              600: const Color(0XFF7B3F00),
              700: const Color(0XFF7B3F00),
              800: const Color(0XFF7B3F00),
              900: const Color(0XFF7B3F00),
            },
          ),
          scaffoldBackgroundColor: Color(0XFFF1EBE5),
          accentColor: Color(0XFF7B3F00),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: OnboardingScreen.id,
        routes: {
          OnboardingScreen.id: (context) => OnboardingScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          DishScreen.id: (context) => DishScreen(),
          OtherScreen.id: (context) => OtherScreen(),
        });
  }
}
