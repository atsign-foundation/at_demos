import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_dude/services/navigation_service.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_onboarding_flutter/screen/at_onboarding_reset_screen.dart';
// import 'package:at_onboarding_flutter/screen/at_onboarding_reset_screen.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

class AuthenticationService {
  static final AuthenticationService _singleton =
      AuthenticationService._internal();
  AuthenticationService._internal();

  factory AuthenticationService.getInstance() {
    return _singleton;
  }

  AtOnboardingConfig getAtOnboardingConfig({
    required AtClientPreference atClientPreference,
  }) =>
      AtOnboardingConfig(
        atClientPreference: atClientPreference,
        rootEnvironment: AtEnv.rootEnvironment,
        domain: AtEnv.rootDomain,
        appAPIKey: AtEnv.appApiKey,
      );

  Future<AtOnboardingResult> onboard() async {
    var dir = await getApplicationSupportDirectory();

    var atClientPreference = AtClientPreference()
      ..rootDomain = AtEnv.rootDomain
      ..namespace = AtEnv.appNamespace
      ..hiveStoragePath = dir.path
      ..commitLogPath = dir.path
      ..isLocalStoreRequired = true;

    return AtOnboarding.onboard(
      context: NavigationService.navKey.currentContext!,
      config: getAtOnboardingConfig(atClientPreference: atClientPreference),
    );
  }

  Future<AtOnboardingResetResult> reset() async {
    var dir = await getApplicationSupportDirectory();

    var atClientPreference = AtClientPreference()
      ..rootDomain = AtEnv.rootDomain
      ..namespace = AtEnv.appNamespace
      ..hiveStoragePath = dir.path
      ..commitLogPath = dir.path
      ..isLocalStoreRequired = true;

    return AtOnboarding.reset(
      context: NavigationService.navKey.currentContext!,
      config: getAtOnboardingConfig(atClientPreference: atClientPreference),
    );
  }
}
