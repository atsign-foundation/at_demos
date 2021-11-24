import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbs_testing/screens/notify_screen.dart';
import 'package:verbs_testing/services/server_demo_service.dart';

class MonitorScreen extends StatefulWidget {
  final String atSign;

  const MonitorScreen({
    Key key,
    @required this.atSign,
  })  : assert(atSign != null),
        super(key: key);

  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  String notifications = "";
  String monitorStatus = '';
  bool monitorStarted = false;
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();
  List<AtNotification> notificationList = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Monitor Testing"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 35,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        backgroundColor: MaterialStateProperty.all(monitorStarted ? Colors.red : Colors.green),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      child: Text("${monitorStarted ? 'Stop' : 'Start'} Monitor"),
                      onPressed: monitorStarted ? _stop_monitor : _start_monitor,
                      // color: Colors.blueAccent,
                      // textColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      monitorStatus,
                      style: TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (monitorStarted & (notificationList.isEmpty || notificationList == null))
                      CircularProgressIndicator(),
                    if (monitorStarted)
                      for (var data in notificationList)
                        Center(
                          child: Container(
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (data.id != null) CustomText(keyTitle: 'Id', value: data.id),
                                if (data.key != null) CustomText(keyTitle: 'Key', value: data.key),
                                if (data.value != null) CustomText(keyTitle: 'Server Commit Id', value: data.value),
                                if (data.fromAtSign != null) CustomText(keyTitle: 'FromAtSign', value: data.fromAtSign),
                                if (data.dateTime != null)
                                  CustomText(
                                    keyTitle: 'DateTime',
                                    value: DateFormat.yMEd().add_jms().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(data.dateTime.toString()),
                                          ),
                                        ),
                                  ),
                                if (data.operation != null) CustomText(keyTitle: 'Operation', value: data.operation),
                                if (data.status != null) CustomText(keyTitle: 'Status', value: data.status),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _start_monitor() async {
    setState(() {
      monitorStarted = true;
      monitorStatus = "Monitoring started";
    });
    await _serverDemoService.getMonitorService(widget.atSign, chanageText, chanageText, () {
      print('retrying.............');
    }).start();
  }

  _stop_monitor() {
    setState(() {
      monitorStatus = "Monitor stopped";
      notifications = '';
      monitorStarted = false;
      notificationList.clear();
    });
    _serverDemoService.getMonitorService(widget.atSign, chanageText, chanageText, () {
      print('retrying.............');
    }).stop();
  }

  void chanageText(var newText) async {
    try {
      newText = newText.replaceAll('notification: ', '');
      var atNotification = AtNotification.fromJson(jsonDecode(newText));
      if (atNotification != null) {
        setState(() {
          notificationList.clear();
          notificationList.insert(0, atNotification);
        });
      }
    } on FormatException catch (e) {
      print('Format Exception : $e');
    }
  }
}
