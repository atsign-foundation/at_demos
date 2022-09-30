import 'package:flutter/material.dart';
import 'package:iot_receiver/screens/onboarding_screen.dart';
import '../services/hro2_data_service.dart';
import '../screens/devices_screen.dart';
import '../screens/home_screen.dart';
import '../screens/receivers_screen.dart';
import 'new_device_dialog.dart';
import 'new_receiver_dialog.dart';

class HRo2DrawerWidget extends StatelessWidget {
  const HRo2DrawerWidget({Key? key}) : super(key: key);

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
            child: Text('HRo2 Options'),
          ),
          ListTile(
            title: const Text('See HRo2 readings'),
            onTap: () {
              Navigator.of(context).pushNamed(HomeScreen.id);
            },
          ),
          ListTile(
            title: const Text('See all devices'),
            onTap: () {
              Navigator.of(context).pushNamed(DevicesScreen.id);
            },
          ),
          ListTile(
            title: const Text('Add a new device'),
            onTap: () {
              Navigator.of(context).pushNamed(NewHrO2Device.id);
            },
          ),
          ListTile(
            title: const Text('See all receivers'),
            onTap: () {
              Navigator.of(context).pushNamed(ReceiversScreen.id);
            },
          ),
          ListTile(
            title: const Text('Add a new receiver'),
            onTap: () {
              Navigator.of(context).pushNamed(NewHrO2Receiver.id);
            },
          ),
          ListTile(
            title: const Text('Change atSign'),
            onTap: () async {
              Navigator.of(context).pushNamed(OnboardingScreen.id);
            },
          ),
          ListTile(
            title: const Text('Reset app data'),
            onTap: () async {
              await Hro2DataService().deleteAllData();
            },
          ),
        ],
      ),
    );
  }
}
