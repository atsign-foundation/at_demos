// dart packages
import 'dart:io';

// atPlatform packages
import 'package:at_client/at_client.dart';
import 'package:at_cli_commons/at_cli_commons.dart';

// External Packages
import 'package:args/args.dart';
import 'package:chalkdart/chalk.dart';

Future<void> main(List<String> args) async {
  ArgParser argsParser = CLIBase.argsParser
    ..addOption('other-atsign',
        abbr: 'o',
        mandatory: true,
        help: 'The atSign we want to communicate with');

  late final AtClient atClient;
  late final String nameSpace, myAtsign, otherAtsign;
  try {
    var parsed = argsParser.parse(args);
    otherAtsign = parsed['other-atsign'];

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

  // Construct the ID object we will use to do the fetch
  // In this case, if we are @alice, the other atSign is @bob, and the
  // nameSpace is 'demo', then the ID for the message which bob has shared with
  // us would be @alice:message.demo@bob
  AtKey sharedRecordID = AtKey()
    ..key = keyName
    ..sharedBy = otherAtsign
    ..sharedWith = myAtsign
    ..namespace = nameSpace;
  print(sharedRecordID);

  // Equivalent ways of doing the above
  // 1) If you're familiar with ID structure
  // sharedRecordID =
  //     AtKey.fromString('$myAtsign:$keyName.$nameSpace$otherAtsign');
  // print(sharedRecordID);
  // // 2) Using AtKey.shared
  // sharedRecordID =
  //     (AtKey.shared(keyName, namespace: nameSpace, sharedBy: otherAtsign)
  //           ..sharedWith(myAtsign))
  //         .build();
  // print(sharedRecordID);

  try {
    var val = await atClient.get(sharedRecordID);
    stdout.writeln(val.toString());
    stdout.writeln(chalk.brightGreen(val.value));
  } catch (e) {
    print(e.toString());
    print(chalk.brightRed('Null'));
  }
  exit(0);
}
