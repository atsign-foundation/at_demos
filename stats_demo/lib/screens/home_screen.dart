import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:verbs_testing/screens/notify_screen.dart';
import 'package:verbs_testing/services/server_demo_service.dart';

import 'monitor_screen.dart';
import 'sync_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';

  final String atSign;

  const HomeScreen({
    Key? key,
    required this.atSign,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String notifications = 'Empty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(ServerDemoService.getInstance().atSign!),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Test Your verbs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Wrap(
                spacing: 10.0,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  VerbButton(
                    title: 'Monitor',
                    widget: MonitorScreen(atSign: widget.atSign),
                  ),
                  VerbButton(
                    title: 'Sync',
                    widget: SyncScreen(atSign: widget.atSign),
                  ),
                  const VerbButton(
                    title: 'Notify',
                    widget: NotifyScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerbButton extends StatelessWidget {
  final String title;
  final Widget widget;
  const VerbButton({Key? key, required this.title, required this.widget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
      },
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
