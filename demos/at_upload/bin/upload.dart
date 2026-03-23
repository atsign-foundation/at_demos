import 'dart:io';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:chalkdart/chalk.dart';
import 'package:mime/mime.dart' as mime;
import 'package:args/args.dart';

void main(List<String> args) async {
  final p = createArgsParser();

  String dirName, suffix;
  bool dryRun;
  final CLIBase cli;
  try {
    final ar = p.parse(args);

    dirName = ar['fs-dir'].trim();
    suffix = ar['at-dir'].trim();
    dryRun = ar['dry-run'];

    cli = await CLIBase.fromCommandLineArgs(args, parser: p);
  } catch (e) {
    stderr.writeln(p.usage);
    stderr.writeln('\n$e');
    exit(1);
  }

  final ps = Platform.pathSeparator;
  final dir = Directory(dirName);
  final discard = dir.absolute.path;

  List<FileSystemEntity> entities = dir.listSync(
    recursive: true,
    followLinks: false,
  )..removeWhere((e) => e is! File);

  if (entities.isEmpty) {
    stderr.writeln('No files in directory $dirName');
    exit(1);
  }
  int maxLen = 0;
  for (final fse in entities) {
    int thisLen = fse.absolute.path.replaceFirst(discard, '').length + 1;
    if (thisLen > maxLen) {
      maxLen = thisLen;
    }
  }

  if (dryRun) {
    stderr.writeln(chalk.gray('Dry run - will not upload'));
  } else {
    stderr.writeln(chalk.blue('Uploading files'));
  }
  for (final fse in entities) {
    String filePath = fse.absolute.path.replaceFirst(discard, '');
    if (filePath.startsWith(ps)) {
      filePath = filePath.substring(1);
    }

    String atKeyStr = suffix;
    List<String> filePathParts = filePath.split(ps);
    String fileName = filePathParts.removeLast();
    for (String p in filePathParts) {
      atKeyStr = '$p.$atKeyStr';
    }
    atKeyStr = 'public:$fileName.$atKeyStr${cli.atSign}';
    List<int> bytes = File(fse.absolute.path).readAsBytesSync();
    String msg = '${bytes.length.toString().padLeft(10)} bytes: ${filePath.padLeft(maxLen)} => $atKeyStr';
    if (dryRun) {
      stderr.writeln(chalk.gray(msg));
    } else {
      stderr.writeln(chalk.green(msg));
    }
    if (mime.lookupMimeType(filePath) == null) {
      stderr.writeln(
        chalk.orange(
          'Cannot determine mime type of $filePath'
          ' - will be returned by atServer as application/octet-stream',
        ),
      );
    }
    if (dryRun) {
      continue;
    }

    // Not a dry run: do the actual upload
    await cli.atClient.putBinary(
      AtKey.fromString(atKeyStr),
      bytes,
      putRequestOptions: PutRequestOptions()..useRemoteAtServer = true,
    );
  }

  exit(0);
}

ArgParser createArgsParser() {
  final p = CLIBase.createArgsParser(
    namespace: 'demo',
    hide: {
      'namespace',
      'home-dir',
      'key-file',
      'storage-dir',
      'pass-phrase',
      'max-connect-attempts',
      'never-sync',
    },
  );
  p.addOption(
    'fs-dir',
    help:
    'path to filesystem directory whose contents'
        ' you wish to upload',
    mandatory: true,
  );
  p.addOption(
    'at-dir',
    help:
    'namespace to which the files will be'
        ' uploaded',
    mandatory: true,
  );
  p.addFlag('dry-run', defaultsTo: false);

  return p;
}