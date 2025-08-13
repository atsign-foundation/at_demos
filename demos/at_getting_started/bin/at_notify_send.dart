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
  } catch (e) {
    print(argsParser.usage);
    print(e);
    exit(1);
  }

  String keyName = 'message';

  AtKey sharedRecordID = AtKey()
    ..key = keyName
    ..sharedBy = myAtsign
    ..sharedWith = otherAtsign
    ..namespace = nameSpace
    ..metadata = (Metadata()
      ..ttl = 60000 // expire after 60 seconds
      ..ttr = -1); // allow recipient to keep a cached copy

  await atClient.notificationService.notify(
      NotificationParams.forUpdate(sharedRecordID, value: message),
      waitForFinalDeliveryStatus: false,
      checkForFinalDeliveryStatus: false);

  // Using notifications we get all the updates
  // for (int a = 1; a < 101; a++) {
  //   await atClient.notificationService.notify(
  //       NotificationParams.forUpdate(sharedRecordID, value: a.toString()),
  //       waitForFinalDeliveryStatus: false,
  //       checkForFinalDeliveryStatus: false);
  // }

  await Future.delayed(Duration(seconds: 1));
  exit(0);
}
