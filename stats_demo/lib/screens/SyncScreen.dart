import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbsTesting/services/server_demo_service.dart';
import 'package:at_client/src/manager/sync_manager.dart';
import 'package:at_client/src/util/sync_util.dart';

class SyncScreen extends StatefulWidget {
  static const String id = 'home';

  final String atSign;

  const SyncScreen({
    Key key,
    @required this.atSign,
  })  : assert(atSign != null),
        super(key: key);

  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();
  String syncText = '';
  String commitIdBeforeSync;
  String commitIdAfterSync;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sync Testing"),
        ),
        body: Center(
          child: Column(
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
                      RaisedButton(
                        child: Text("Sync Once"),
                        onPressed: _syncOnce,
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                      RaisedButton(
                        child: Text("Sync "),
                        onPressed: _sync,
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    syncText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (commitIdBeforeSync != null)
                    Text('commitIdBeforeSync: ' + commitIdBeforeSync,
                        style: TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20)),
                  SizedBox(
                    height: 20,
                  ),
                  if (commitIdAfterSync != null)
                    Text('commitIdAfterSync: ' + commitIdAfterSync,
                        style: TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20)),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> onSyncComplete(SyncManager manager) async {
    await Future.delayed(Duration(seconds: 3));
    commitIdAfterSync =
        (await SyncUtil.getLastSyncedEntry(null, atSign: _serverDemoService.atSign))?.commitId?.toString();
    setState(() => {syncText = "Completed"});
  }

  void onSyncException(SyncManager manager, Exception e) {
    setState(() {
      syncText = "SyncOnce throws " + e.toString();
    });
  }

  _sync() async {
    commitIdBeforeSync = null;
    commitIdAfterSync = null;
    commitIdBeforeSync =
        (await SyncUtil.getLastSyncedEntry(null, atSign: _serverDemoService.atSign))?.commitId?.toString();
    setState(() {
      syncText = "Sync started";
    });
    await _serverDemoService.sync(onSyncComplete);
  }

  _syncOnce() async {
    commitIdBeforeSync = null;
    commitIdAfterSync = null;
    commitIdBeforeSync =
        (await SyncUtil.getLastSyncedEntry(null, atSign: _serverDemoService.atSign))?.commitId?.toString();
    setState(() {
      syncText = "SyncOnce started";
    });
    await _serverDemoService.syncOnce(onSyncComplete);
  }
}
