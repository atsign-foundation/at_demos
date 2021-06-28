import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:verbsTesting/screens/notify_screen.dart';
import 'package:verbsTesting/services/server_demo_service.dart';

import 'MonitorScreen.dart';
import 'SyncScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';

  final String atSign;

  const HomeScreen({
    Key key,
    @required this.atSign,
  })  : assert(atSign != null),
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String notifications = "Empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(ServerDemoService.getInstance().atSign),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Test Your verbs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
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
                  VerbButton(
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
  VerbButton({@required this.title, @required this.widget});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
        },
        child: Text(this.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));
  }
}
