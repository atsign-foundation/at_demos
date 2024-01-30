import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_file_share/src/file_send_params.dart';
import 'package:at_file_share/src/service/file_receiver.dart';
import 'package:at_file_share/src/service/file_sender.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:at_cli_commons/at_cli_commons.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return CLIBase.argsParser
    ..addOption('mode',
        abbr: 'm', mandatory: true, help: 'File sharing mode - send or receive')
    ..addOption('receiver',
        abbr: 'r', mandatory: true, help: 'atsign receiving the shared file')
    ..addOption('filePath',
        abbr: 'f', mandatory: false, help: 'path of file in local to share')
    ..addOption('downloadDir',
        abbr: 'o', mandatory: false, help: 'download dir when receiving files')
    ..addOption('bucketName',
        abbr: 'b',
        mandatory: false,
        help: 'bucket name of storj to upload the file');
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
    var atClient = (await CLIBase.fromCommandLineArgs(arguments)).atClient;
    print('mode: $mode');
    if (mode == 'send') {
      String receiver = results['receiver'];
      var params = FileSendParams()
        ..receiverAtSign = receiver
        ..filePath = results['filePath']
        ..bucketName = results['bucketName'];

      await FileSender(atClient).sendFile(params);
    } else if (mode == 'receive') {
      await FileReceiver(atClient).receiveFile(results['downloadDir']);
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
