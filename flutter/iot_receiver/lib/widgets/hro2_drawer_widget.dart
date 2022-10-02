import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_receiver/screens/data_owners_screen.dart';
import 'package:iot_receiver/screens/onboarding_screen.dart';
import 'package:iot_receiver/widgets/new_data_owner_dialog.dart';
import '../services/hro2_data_service.dart';
import '../screens/devices_screen.dart';
import '../screens/home_screen.dart';
import '../screens/receivers_screen.dart';
import 'new_device_dialog.dart';
import 'new_receiver_dialog.dart';

class HRo2DrawerWidget extends StatefulWidget {
  const HRo2DrawerWidget({Key? key}) : super(key: key);

  @override
  State<HRo2DrawerWidget> createState() => _HRo2DrawerWidgetState();
}

class _HRo2DrawerWidgetState extends State<HRo2DrawerWidget> {
  final bool isAdmin =
      AtClientManager.getInstance().atClient.getCurrentAtSign() ==
          "@mwcmanager";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text('HRO2 Options'),
          ),
          ListTile(
            title: const Text('See HRo2 readings'),
            onTap: () {
              Navigator.of(context).pushNamed(HomeScreen.id);
            },
          ),
          if (isAdmin)
            ListTile(
              title: const Text('See all devices'),
              onTap: () {
                Navigator.of(context).pushNamed(DevicesScreen.id);
              },
            ),
          if (isAdmin)
            ListTile(
              title: const Text('Add a new device'),
              onTap: () {
                Navigator.of(context).pushNamed(NewHrO2Device.id);
              },
            ),
          if (!isAdmin)
            ListTile(
              title: const Text('See all receivers'),
              onTap: () {
                Navigator.of(context).pushNamed(ReceiversScreen.id);
              },
            ),
          if (!isAdmin)
            ListTile(
              title: const Text('Add a new receiver'),
              onTap: () {
                Navigator.of(context).pushNamed(NewHrO2Receiver.id);
              },
            ),
          if (isAdmin)
            ListTile(
              title: const Text('Add a new data owner'),
              onTap: () {
                Navigator.of(context).pushNamed(NewHrO2DataOwner.id);
              },
            ),
          if (isAdmin)
            ListTile(
              title: const Text('See all data owners'),
              onTap: () {
                Navigator.of(context).pushNamed(DataOwnersScreen.id);
              },
            ),
          ListTile(
            title: const Text('Change atSign'),
            onTap: () async {
              Navigator.of(context).pushNamed(OnboardingScreen.id);
            },
          ),
          if (isAdmin)
            ListTile(
              title: const Text('Reset app data'),
              onTap: () async {
                Hro2DataService().deleteAllData();
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            title: const Text('Close'),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
