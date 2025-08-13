// dart packages
import 'dart:io';

// atPlatform packages
import 'package:at_client/at_client.dart';
import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_utils/at_logger.dart';

// External Packages
import 'package:chalkdart/chalk.dart';

Future<void> main(List<String> args) async {
  late final AtClient atClient;
  late final String nameSpace, myAtsign;
  try {
    CLIBase cliBase = await CLIBase.fromCommandLineArgs(args);
    atClient = cliBase.atClient;

    nameSpace = atClient.getPreferences()!.namespace!;
    myAtsign = atClient.getCurrentAtSign()!;
  } catch (e) {
    print(CLIBase.argsParser.usage);
    print(e);
    exit(1);
  }

  final AtSignLogger logger = AtSignLogger(' at_notify ');

  atClient.notificationService
      .subscribe(regex: 'message.$nameSpace@', shouldDecrypt: true)
      .listen(((notification) async {
    stdout.writeln(chalk.blue(notification.key));
    String keyName = notification.key
        .replaceAll('${notification.to}:', '')
        .replaceAll('.$nameSpace${notification.from}', '');
    if (keyName == 'message') {
      logger.info(
          'message received from ${notification.from} notification id : ${notification.id}');
      var talk = notification.value;
      print(chalk.brightGreen.bold('\r\x1b[K${notification.from}: ') +
          chalk.brightGreen(talk));

      stdout.write(chalk.brightYellow('$myAtsign: '));
    }
  }),
          onError: (e) => logger.severe('Notification Failed:$e'),
          onDone: () => logger.info('Notification listener stopped'));
}
