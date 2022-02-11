import 'package:flutter/material.dart';


import 'package:iot_reciever/widgets/onboarding_dialog.dart';

class OnboardingScreen extends StatelessWidget {
  static const String id = '/onboarding';
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            "HR02 DISPLAY",
            style: TextStyle(
                fontFamily: 'LED',
                fontSize: 38,
                letterSpacing: 5,
                color: Colors.green,
                fontWeight: FontWeight.bold),
          ),
          OnboardingDialog()
        ],
      )),
    );
  }
}
