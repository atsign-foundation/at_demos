import 'package:at_dude/services/navigation_service.dart';
import 'package:flutter/material.dart';

class Snackbars extends StatelessWidget {
  const Snackbars({Key? key}) : super(key: key);

  static void errorSnackBar({
    required String errorMessage,
  }) {
    ScaffoldMessenger.of(NavigationService.navKey.currentContext!)
        .showSnackBar(SnackBar(
      content: Text(
        errorMessage,
        textAlign: TextAlign.center,
      ),
      backgroundColor:
          Theme.of(NavigationService.navKey.currentContext!).errorColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
