import 'package:at_dude/commands/base_command.dart';
import 'package:at_dude/commands/onboard_command.dart';
import 'package:at_onboarding_flutter/screen/at_onboarding_reset_screen.dart';

class ResetCommand extends BaseCommand {
  Future<void> run() async {
    var resetResult = await authenticationService.reset();

    // Everything Below New

    switch (resetResult) {
      case AtOnboardingResetResult.success:
        OnboardCommand().run();
        break;

      case AtOnboardingResetResult.cancelled:
        break;
    }
  }
}
