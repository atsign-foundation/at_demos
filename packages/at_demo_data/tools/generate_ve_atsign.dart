import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:encrypt/encrypt.dart';

const String usage =
    'Usage: dart run tools/generate_ve_atsign.dart @atsign /path/to/new-private-directory legacy|apkam';

enum VeAuthMode { legacy, apkam }

void main(List<String> arguments) {
  if (arguments.length != 3 ||
      !RegExp(r'^@[a-z][a-z0-9]*$').hasMatch(arguments.first) ||
      !<String>['legacy', 'apkam'].contains(arguments[2])) {
    stderr.writeln(usage);
    exitCode = 64;
    return;
  }

  try {
    generateVeAtsign(arguments[0], Directory(arguments[1]),
        authMode: VeAuthMode.values.byName(arguments[2]));
    stdout.writeln('Generated private VE credentials in ${arguments[1]}');
  } on Exception catch (error) {
    stderr.writeln('Unable to generate VE credentials: $error');
    exitCode = 1;
  }
}

void generateVeAtsign(String atsign, Directory output,
    {required VeAuthMode authMode}) {
  if (!RegExp(r'^@[a-z][a-z0-9]*$').hasMatch(atsign)) {
    throw ArgumentError.value(atsign, 'atsign', 'Expected an ASCII Atsign');
  }
  if (output.existsSync()) {
    throw FileSystemException('Output directory already exists', output.path);
  }

  ProcessResult created = Process.runSync('mkdir', <String>[
    '-m',
    '700',
    output.absolute.path,
  ]);
  if (created.exitCode != 0) {
    throw FileSystemException(
        'Could not create private output directory', output.path);
  }

  try {
    RSAKeypair pkam = RSAKeypair.fromRandom(keySize: 2048);
    RSAKeypair encryption = RSAKeypair.fromRandom(keySize: 2048);
    RSAKeypair apkam = RSAKeypair.fromRandom(keySize: 2048);
    String selfKey = base64Encode(_randomBytes(32));
    String apkamKey = base64Encode(_randomBytes(32));
    String sharedKey = base64Encode(_randomBytes(32));

    Map<String, String> credentials = <String, String>{
      'atsign': atsign,
      'authMode': authMode.name,
      'cramKey': _randomBytes(64)
          .map((int byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join(),
      'pkamPublicKey': pkam.publicKey.toString(),
      'pkamPrivateKey': pkam.privateKey.toString(),
      'encryptionPublicKey': encryption.publicKey.toString(),
      'encryptionPrivateKey': encryption.privateKey.toString(),
      'aesKey': selfKey,
      'apkamSymmetricKey': apkamKey,
      'apkamPublicKey': apkam.publicKey.toString(),
      'apkamPrivateKey': apkam.privateKey.toString(),
    };
    Encrypter encrypter = Encrypter(AES(Key.fromBase64(selfKey)));
    IV iv = IV(Uint8List(16));
    Map<String, String> atKeys = <String, String>{
      'aesPkamPublicKey':
          encrypter.encrypt(credentials['pkamPublicKey']!, iv: iv).base64,
      'aesPkamPrivateKey':
          encrypter.encrypt(credentials['pkamPrivateKey']!, iv: iv).base64,
      'aesEncryptPublicKey':
          encrypter.encrypt(credentials['encryptionPublicKey']!, iv: iv).base64,
      'aesEncryptPrivateKey': encrypter
          .encrypt(credentials['encryptionPrivateKey']!, iv: iv)
          .base64,
      'selfEncryptionKey': selfKey,
      atsign: sharedKey,
    };

    _writePrivateFile(
        File('${output.path}/$atsign.atKeys'), jsonEncode(atKeys));
    _writePrivateFile(File('${output.path}/$atsign.ve-credentials.json'),
        jsonEncode(credentials));
    String name = atsign.substring(1);
    _writePrivateFile(File('${output.path}/${name}_keys.dart'),
        _dartKeysSource(name, credentials));
  } on Exception {
    output.deleteSync(recursive: true);
    rethrow;
  }
}

String _dartKeysSource(String name, Map<String, String> credentials) {
  String className = '${name[0].toUpperCase()}${name.substring(1)}Keys';
  StringBuffer source = StringBuffer()
    ..writeln("part of '../at_demo_credentials.dart';")
    ..writeln()
    ..writeln('class $className {');
  for (String field in <String>[
    'cramKey',
    'pkamPrivateKey',
    'pkamPublicKey',
    'encryptionPrivateKey',
    'encryptionPublicKey',
    'aesKey',
    'apkamSymmetricKey',
    'apkamPrivateKey',
    'apkamPublicKey',
  ]) {
    source.writeln(
        '  static const String _$field = ${jsonEncode(credentials[field])};');
  }
  source.writeln('}');
  return source.toString();
}

Uint8List _randomBytes(int length) {
  Random random = Random.secure();
  return Uint8List.fromList(
    List<int>.generate(length, (int index) => random.nextInt(256)),
  );
}

void _writePrivateFile(File file, String content) {
  file.writeAsStringSync('$content\n', flush: true);
  ProcessResult result = Process.runSync('chmod', <String>['600', file.path]);
  if (result.exitCode != 0) {
    throw FileSystemException(
        'Could not restrict credential file permissions', file.path);
  }
}
