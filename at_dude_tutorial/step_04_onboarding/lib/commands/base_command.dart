import 'package:provider/provider.dart';

import '../services/services.dart';

abstract class BaseCommand {
  // Services
  AuthenticationService authenticationService =
      NavigationService.navKey.currentContext!.read();
}
