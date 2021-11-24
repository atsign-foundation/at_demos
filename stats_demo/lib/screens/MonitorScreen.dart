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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text("Start Monitor"),
                          onPressed: _start_monitor,
                          // color: Colors.blueAccent,
                          // textColor: Colors.white,
                        ),
                        ElevatedButton(
                          child: Text("Stop Monitor"),
                          onPressed: _stop_monitor,
                          // color: Colors.blueAccent,
                          // textColor: Colors.white,
                        ),
                      ],
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
                    for (var data in notificationList)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueGrey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(keyTitle: 'From', value: data.fromAtSign),
                                CustomText(keyTitle: 'Title', value: data.key),
                                if (data.dateTime != null)
                                  CustomText(
                                    keyTitle: 'DateTime',
                                    value: DateFormat.yMEd().add_jms().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                              data.dateTime.toString(),
                                            ),
                                          ),
                                        ),
                                  ),
                                if (data.value != null) CustomText(keyTitle: 'Message', value: data.value),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _showNotificationDetails(data);
                                    },
                                    icon: Icon(Icons.info_outline)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Text(
                      notifications,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _showNotificationDetails(AtNotification data) {
    showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, stateSet) {
            return AlertDialog(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (data.id != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                      child: CustomText(keyTitle: 'Id', value: data.id),
                    ),
                  if (data.key != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Key', value: data.key),
                    ),
                  if (data.value != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Value', value: data.value),
                    ),
                  if (data.fromAtSign != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'FromAtSign', value: data.fromAtSign),
                    ),
                  if (data.dateTime != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(
                        keyTitle: 'DateTime',
                        value: DateFormat.yMEd().add_jms().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(data.dateTime.toString()),
                              ),
                            ),
                      ),
                    ),
                  if (data.operation != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Operation', value: data.operation),
                    ),
                  if (data.status != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CustomText(keyTitle: 'Status', value: data.status),
                    ),
                ],
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(_), child: Text('Close'))],
            );
          });
        });
  }

  _start_monitor() async {
    setState(() {
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
        // var result = await _serverDemoService.getFromNotification(atNotification);
        // atNotification.value = result;
        setState(() {
          notificationList.clear();
          notificationList.insert(0, atNotification);
        });
        // });
      }
    } on FormatException catch (e) {
      print('Format Exception : $e');
    }
  }
}
