import 'dart:io';

import 'package:args/args.dart';
import 'package:at_file_share/src/file_send_params.dart';
import 'package:at_file_share/src/service/file_receiver.dart';
import 'package:at_file_share/src/service/file_sender.dart';
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
  stderr.writeln('Usage: dart at_file_share.dart <flags> [arguments]');
  stderr.writeln(argParser.usage);
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
    stderr.writeln('mode: $mode');
    if (mode == 'send') {
      String receiver = results['receiver'];
      var params = FileSendParams()
        ..receiverAtSign = receiver
        ..filePath = results['filePath']
        ..bucketName = results['bucketName'];

      await FileSender(atClient).sendFile(params);
      exit(0);
    } else if (mode == 'receive') {
      final receiver = FileReceiver(atClient, results['downloadDir']);
      await receiver.startListening();
      receiver.received.listen((filePath) {
        stderr.writeln('Downloaded file: $filePath');
      });
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    stderr.writeln(e.message);
    stderr.writeln('');
    printUsage(argParser);
  }
}
