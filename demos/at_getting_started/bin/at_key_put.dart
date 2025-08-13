// dart packages
import 'dart:io';

// atPlatform packages
import 'package:at_client/at_client.dart';
import 'package:at_cli_commons/at_cli_commons.dart';

// External Packages
import 'package:args/args.dart';

Future<void> main(List<String> args) async {
  ArgParser argsParser = CLIBase.argsParser
    ..addOption('other-atsign',
        abbr: 'o',
        mandatory: true,
        help: 'The atSign we want to communicate with')
    ..addOption('message',
        abbr: 'm', mandatory: true, help: 'The message we want to send');

  late final AtClient atClient;
  late final String nameSpace, myAtsign, otherAtsign, message;
  try {
    var parsed = argsParser.parse(args);
    otherAtsign = parsed['other-atsign'];
    message = parsed['message'];

    CLIBase cliBase =
        await CLIBase.fromCommandLineArgs(args, parser: argsParser);
    atClient = cliBase.atClient;

    nameSpace = atClient.getPreferences()!.namespace!;
    myAtsign = atClient.getCurrentAtSign()!;

    // await waitForInitialSync(atClient);
  } catch (e) {
    print(argsParser.usage);
    print(e);
    exit(1);
  }

  String keyName = 'message';

  // For demo purposes, we will talk direct to the remote atServer rather than
  // use the local datastore, so we don't have to wait for a local-to-atServer
  // sync to complete.
  PutRequestOptions pro = PutRequestOptions()..useRemoteAtServer = true;

  AtKey sharedRecordID = AtKey()
    ..key = keyName
    ..sharedBy = myAtsign
    ..sharedWith = otherAtsign
    ..namespace = nameSpace
    ..metadata = (Metadata()
      ..ttl = 60000 // expire after 60 seconds
      ..ttr = -1); // allow recipient to keep a cached copy

  print('\r\n ${sharedRecordID.toString()}   :  $message');

  //await atClient.delete(sharedRecordID);
  await atClient.put(sharedRecordID, message, putRequestOptions: pro);

  // Using atkeys we get the latest value
  // int a = 1;
  // while (a < 20) {
  //   await atClient.put(sharedRecordID, a.toString(), putRequestOptions: pro);
  //   a++;
  // }

  exit(0);
}
