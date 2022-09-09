import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contacts_flutter/services/contact_service.dart';
import 'package:at_dude/commands/base_command.dart';
import 'package:at_dude/data/profile_data.dart';

class ContactDetailsCommand extends BaseCommand {
  Future<void> run() async {
    final atClientManager = AtClientManager.getInstance();
    var c = ContactService();
    c.atClientManager = atClientManager;

    return c
        .getContactDetails(atClientManager.atClient.getCurrentAtSign(), null)
        .then(
      (value) {
        contactsModel.profileData =
            ProfileData(name: value['name'], profileImage: value['image']);
      },
    );
  }
}
