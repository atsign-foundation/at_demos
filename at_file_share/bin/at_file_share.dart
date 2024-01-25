import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_file_share/src/file_send_params.dart';
import 'package:at_file_share/src/service/file_receiver.dart';
import 'package:at_file_share/src/service/file_sender.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addOption(
      'mode',
      abbr: 'm',
      mandatory: true,
      help: 'File sharing mode - send or receive',
    )
    ..addOption('atKeysFilePath',
        abbr: 'k', mandatory: false, help: 'atKeys file of the current atsign')
    ..addOption('sender',
        abbr: 's', mandatory: false, help: 'atsign sending the file')
    ..addOption('receiver',
        abbr: 'r', mandatory: false, help: 'atsign receiving the shared file')
    ..addOption('filePath',
        abbr: 'f', mandatory: false, help: 'path of file in local to share')
    ..addOption('downloadDir',
        abbr: 'd', mandatory: false, help: 'download dir when receiving files');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart at_file_share.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    String mode = results['mode'];
    print('mode: $mode');
    AtOnboardingPreference atOnboardingPreference = AtOnboardingPreference()
      ..namespace =
          'zetta' // unique identifier that can be used to identify data from your app
      ..atKeysFilePath = results['atKeysFilePath']
      ..rootDomain = 'vip.ve.atsign.zone';

    if (mode == 'send') {
      String receiver = results['receiver'];
      String sender = results['sender'];
      var params = FileSendParams()
        ..receiverAtSign = receiver
        ..filePath = results['filePath'];
      AtOnboardingService? onboardingService =
          AtOnboardingServiceImpl(sender, atOnboardingPreference);
      await onboardingService.authenticate(); // when authenticating
      await FileSender(onboardingService.atClient!).sendFile(params);
    } else if (mode == 'receive') {
      String receiver = results['receiver'];
      AtOnboardingService? onboardingService =
          AtOnboardingServiceImpl(receiver, atOnboardingPreference);
      await onboardingService.authenticate(); // when authenticating
      await FileReceiver(onboardingService.atClient!)
          .receiveFile(results['downloadDir']);
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
