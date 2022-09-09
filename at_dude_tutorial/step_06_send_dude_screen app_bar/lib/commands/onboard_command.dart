import 'package:at_dude/commands/base_command.dart';
import 'package:at_dude/services/navigation_service.dart';
import 'package:at_dude/views/screens/send_dude_screen.dart';
import 'package:at_dude/views/widgets/snackbars.dart';
import 'package:at_onboarding_flutter/at_onboarding_result.dart';
import 'package:flutter/material.dart';

class OnboardCommand extends BaseCommand {
  Future<void> run() async {
    var onboardingResult = await authenticationService.onboard();
    var context = NavigationService.navKey.currentContext!;
    switch (onboardingResult.status) {
      case AtOnboardingResultStatus.success:
        Navigator.popAndPushNamed(context, SendDudeScreen.routeName);
        break;
      case AtOnboardingResultStatus.error:
        Snackbars.errorSnackBar(errorMessage: 'An error has occurred');
        break;
      case AtOnboardingResultStatus.cancel:
        break;
    }
  }
}
