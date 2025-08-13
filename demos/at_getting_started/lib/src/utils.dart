import 'dart:io';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:chalkdart/chalk.dart';

var chalk = Chalk();

Future<void> waitForInitialSync(AtClient atClient) async {
  // Wait for initial sync to complete
  stdout.write(chalk.brightBlue("Syncing your data."));
  var mySyncListener = MySyncProgressListener();
  atClient.syncService.addProgressListener(mySyncListener);
  while (!mySyncListener.syncComplete) {
    await Future.delayed(Duration(milliseconds: 250));
    stdout.write(chalk.brightBlue('.'));
  }
}
