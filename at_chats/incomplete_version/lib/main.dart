import 'package:at_chat_flutter_example/screens/third_screen.dart';
import 'package:at_chat_flutter_example/screens/second_screen.dart';
import 'package:at_chat_flutter_example/screens/first_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '@Protocol Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: FirstScreen.id,
      routes: {
        FirstScreen.id: (context) => FirstScreen(),
        SecondScreen.id: (context) => SecondScreen(),
        ThirdScreen.id: (context) => ThirdScreen(),
      },
    );
  }
}