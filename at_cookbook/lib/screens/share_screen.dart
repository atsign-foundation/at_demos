import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_client/src/service/notification_service.dart';

class ShareScreen extends StatefulWidget {
  static final String id = 'share';
  final DishWidget? dishWidget;

  ShareScreen({@required this.dishWidget});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String? _otherAtSign;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF7B3F00),
        title: const Text('Add a dish'),
      ),
      backgroundColor: const Color(0XFFF1EBE5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'choice chef',
                      child: SizedBox(
                        height: 200,
                        child: Image.asset(
                          'assets/chef.png',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Enter an @sign to chat with'),
                    onChanged: (String value) {
                      _otherAtSign = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                    text: 'Share Cuisine',
                    color: const Color(0XFF7B3F00),
                    path: () async => _share(context, _otherAtSign!),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // The _share function will pass the dishWidget values (The entire recipe) to a specified atsign
  Future<void> _share(BuildContext context, String? sharedWith) async {
    // If an atsign has been chosen to share the recipe with
    if (sharedWith != null) {
      String? atSign =
          AtClientManager.getInstance().atClient.getCurrentAtSign();
      // Create an AtKey object called lookup to act as
      // a buffer for the recipe itself
      AtKey lookup = AtKey()
        // Specifying the attributes of lookup, such as the title
        // of the recipe and the atsign we are authenticated in as
        ..key = widget.dishWidget!.title
        ..sharedWith = atSign;

      // getting the values of the recipe as a string to
      // pass through the secondary servers
      String value =
          (await AtClientManager.getInstance().atClient.get(lookup)).value;

      // Instanstiating the Time To Refresh (ttr) metadata attribute
      // as -1 to cache on the secondary server that has received the recipe.
      // Defining it as -1 will tell the secondary server that the cached key will
      // not have a change in value at any point in time
      Metadata metadata = Metadata()..ttr = 1;

      // create an AtKey object to pass through the secondary server
      AtKey atKey = AtKey()
        // Specifying the attributes of the AtKey object, such as the title of the
        // recipe, the metadata value we defined earlier, the atsign that will be
        // sending the recipe, and which atsign will be receiving the recipe
        ..key = widget.dishWidget!.title
        ..metadata = metadata
        ..sharedBy = atSign
        ..sharedWith = sharedWith;

      // Instantiating the operation value as an update notification.
      // The atsign who is receiving the notification will cache the value
      // sent in either an already pre-existing version of the key
      // and update the value with the new value sent,
      // or create an entirely new key to store the value in
      //OperationEnum operation = OperationEnum.update;
      // Pass the correct variables through the notify verb to send to the specified
      // secondary server
      await AtClientManager.getInstance().atClient.put(atKey, value);
      NotificationService notificationService =
          AtClientManager.getInstance().notificationService;

      NotificationResult isNotified =
          await notificationService.notify(NotificationParams.forUpdate(atKey));

      // This will take the user from the share screen back to the recipe screen
      if (isNotified.notificationStatusEnum ==
          NotificationStatusEnum.delivered) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Shared successfully',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to notify',
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }
}
