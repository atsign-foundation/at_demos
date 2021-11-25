import 'package:at_client/src/service/sync_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbs_testing/services/server_demo_service.dart';
import 'package:at_client/src/util/sync_util.dart';

class SyncScreen extends StatefulWidget {
  static const String id = 'home';

  final String atSign;

  const SyncScreen({
    Key? key,
    required this.atSign,
  }) : super(key: key);

  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final ServerDemoService _serverDemoService = ServerDemoService.getInstance();
  String syncText = '';
  String? commitIdBeforeSync;
  String? commitIdAfterSync;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sync Testing'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 35,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Sync '),
                        onPressed: _sync,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    syncText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (commitIdBeforeSync != null)
                    Text('commitIdBeforeSync: ' + commitIdBeforeSync!,
                        style: const TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20)),
                  const SizedBox(
                    height: 20,
                  ),
                  if (commitIdAfterSync != null)
                    Text('commitIdAfterSync: ' + commitIdAfterSync!,
                        style: const TextStyle(color: Colors.black, fontFamily: 'Open Sans', fontSize: 20)),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> onSyncComplete() async {
    await Future.delayed(const Duration(seconds: 3));
    var _commitIdAfterSync =
        (await SyncUtil.getLastSyncedEntry(null, atSign: _serverDemoService.atSign!))?.commitId?.toString();
    setState(() {
      commitIdAfterSync = _commitIdAfterSync;
      syncText = 'Completed';
    });
  }

  void onSyncException(SyncService syncService, Exception e) {
    setState(() {
      syncText = 'SyncOnce throws ' + e.toString();
    });
  }

  _sync() async {
    commitIdBeforeSync = null;
    commitIdAfterSync = null;
    var _commitIdBeforeSync =
        (await SyncUtil.getLastSyncedEntry(null, atSign: _serverDemoService.atSign!))?.commitId?.toString();
    setState(() {
      syncText = 'Sync started';
      commitIdBeforeSync = _commitIdBeforeSync;
    });
    await _serverDemoService.sync(() {}).then((_) async {
      await onSyncComplete();
    }).catchError((e) {
      // onSyncException(_serverDemoService, e);
      print(e.toString());
    });
  }
}
