import 'package:flutter/material.dart';
import 'package:iot_receiver/widgets/onboarding_dialog.dart';

class OnboardingScreen extends StatefulWidget {
  static const String id = '/onboarding_screen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int gridRows = 1;
    if (width > height) {
      gridRows = 2;
    } else {
      gridRows = 1;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          gradient: gridRows > 1
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 240, 181, 178),
                    Color.fromARGB(255, 171, 200, 224)
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 240, 181, 178),
                    Color.fromARGB(255, 171, 200, 224)
                  ],
                ),
          image: const DecorationImage(
            opacity: .15,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            image: AssetImage(
              'assets/images/blood-pressure.png',
            ),
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              "HR02 DISPLAY",
              style: TextStyle(
                  fontSize: 38,
                  letterSpacing: 5,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
            OnboardingDialog()
          ],
        )),
      ),
    );
  }
}
