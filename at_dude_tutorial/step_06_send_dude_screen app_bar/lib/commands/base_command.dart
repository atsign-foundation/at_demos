import 'package:provider/provider.dart';

import '../models/contacts_model.dart';
import '../services/services.dart';

abstract class BaseCommand {
  // Services
  AuthenticationService authenticationService =
      NavigationService.navKey.currentContext!.read();

  // Models
  ContactsModel contactsModel = NavigationService.navKey.currentContext!.read();
}
