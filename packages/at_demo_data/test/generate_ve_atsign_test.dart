import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:encrypt/encrypt.dart';
import 'package:test/test.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;

import '../tools/generate_ve_atsign.dart' as generator;

void main() {
  late Directory temporary;

  setUp(() {
    temporary = Directory.systemTemp.createTempSync('ve-credentials-test-');
  });

  tearDown(() {
    temporary.deleteSync(recursive: true);
  });

  test('generates distinct VE credentials and readable legacy atKeys', () {
    Directory output = Directory('${temporary.path}/private');
    generator.generateVeAtsign('@testuser', output,
        authMode: generator.VeAuthMode.legacy);

    Map<String, dynamic> credentials = jsonDecode(
      File('${output.path}/@testuser.ve-credentials.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    Map<String, dynamic> atKeys = jsonDecode(
      File('${output.path}/@testuser.atKeys').readAsStringSync(),
    ) as Map<String, dynamic>;

    expect(credentials['atsign'], '@testuser');
    expect(credentials['authMode'], 'legacy');
    expect(credentials['cramKey'], matches(RegExp(r'^[0-9a-f]{128}$')));
    expect(base64Decode(credentials['aesKey'] as String), hasLength(32));
    expect(base64Decode(credentials['apkamSymmetricKey'] as String),
        hasLength(32));
    expect(base64Decode(atKeys['@testuser'] as String), hasLength(32));
    expect(atKeys['selfEncryptionKey'], credentials['aesKey']);
    String dartKeys =
        File('${output.path}/testuser_keys.dart').readAsStringSync();
    expect(dartKeys, contains("part of '../at_demo_credentials.dart';"));
    expect(dartKeys, contains('class TestuserKeys {'));
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
      expect(dartKeys,
          contains('String _$field = ${jsonEncode(credentials[field])};'));
    }

    Encrypter decrypter = Encrypter(
      AES(Key.fromBase64(credentials['aesKey'] as String)),
    );
    IV iv = IV(Uint8List(16));
    for (MapEntry<String, String> entry in <String, String>{
      'aesPkamPublicKey': 'pkamPublicKey',
      'aesPkamPrivateKey': 'pkamPrivateKey',
      'aesEncryptPublicKey': 'encryptionPublicKey',
      'aesEncryptPrivateKey': 'encryptionPrivateKey',
    }.entries) {
      expect(
        decrypter.decrypt64(atKeys[entry.key] as String, iv: iv),
        credentials[entry.value],
      );
    }

    RSAPrivateKey pkamPrivate =
        RSAPrivateKey.fromString(credentials['pkamPrivateKey'] as String);
    RSAPublicKey pkamPublic =
        RSAPublicKey.fromString(credentials['pkamPublicKey'] as String);
    expect(pkamPrivate.publicKey.toString(), pkamPublic.toString());
    RSAPrivateKey encryptionPrivate = RSAPrivateKey.fromString(
      credentials['encryptionPrivateKey'] as String,
    );
    RSAPublicKey encryptionPublic = RSAPublicKey.fromString(
      credentials['encryptionPublicKey'] as String,
    );
    expect(encryptionPrivate.publicKey.toString(), encryptionPublic.toString());
    expect(credentials['pkamPrivateKey'],
        isNot(credentials['encryptionPrivateKey']));
    RSAPrivateKey apkamPrivate =
        RSAPrivateKey.fromString(credentials['apkamPrivateKey'] as String);
    RSAPublicKey apkamPublic =
        RSAPublicKey.fromString(credentials['apkamPublicKey'] as String);
    expect(apkamPrivate.publicKey.toString(), apkamPublic.toString());

    if (Platform.isLinux || Platform.isMacOS) {
      List<String> paths = <String>[
        output.path,
        '${output.path}/@testuser.atKeys',
        '${output.path}/@testuser.ve-credentials.json',
        '${output.path}/testuser_keys.dart',
      ];
      for (int index = 0; index < paths.length; index++) {
        ProcessResult mode = Platform.isMacOS
            ? Process.runSync('stat', <String>['-f', '%Lp', paths[index]])
            : Process.runSync('stat', <String>['-c', '%a', paths[index]]);
        expect(mode.stdout.toString().trim(), index == 0 ? '700' : '600');
      }
    }
  });

  test('APKAM mode marks the identity for CRAM-only provisioning', () {
    Directory output = Directory('${temporary.path}/apkam');
    generator.generateVeAtsign('@apkamdemo', output,
        authMode: generator.VeAuthMode.apkam);
    Map<String, dynamic> credentials = jsonDecode(
      File('${output.path}/@apkamdemo.ve-credentials.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    expect(credentials['authMode'], 'apkam');
    expect(credentials['cramKey'], matches(RegExp(r'^[0-9a-f]{128}$')));
    expect(credentials['apkamPublicKey'], isNotEmpty);
    expect(File('${output.path}/apkamdemo_keys.dart').existsSync(), isTrue);
  });

  test('each bundled Atsign has a separate constants file', () {
    for (String atsign in <String>[
      ...at_demo_data.allAtsigns,
      ...at_demo_data.apkamAtsigns,
    ]) {
      if (atsign == 'anonymous') {
        continue;
      }
      String name = atsign.substring(1);
      File source = File('lib/src/constants/${name}_keys.dart');
      expect(source.existsSync(), isTrue, reason: atsign);
      expect(source.readAsStringSync(), contains('String _cramKey'));
    }
  });

  test('rejects invalid Atsigns and refuses to overwrite output', () {
    Directory output = Directory('${temporary.path}/private');
    expect(
        () => generator.generateVeAtsign('@../name', output,
            authMode: generator.VeAuthMode.apkam),
        throwsArgumentError);
    expect(output.existsSync(), isFalse);

    generator.generateVeAtsign('@testuser', output,
        authMode: generator.VeAuthMode.legacy);
    String previous =
        File('${output.path}/@testuser.ve-credentials.json').readAsStringSync();
    expect(
        () => generator.generateVeAtsign('@testuser', output,
            authMode: generator.VeAuthMode.legacy),
        throwsA(isA<FileSystemException>()));
    expect(
        File('${output.path}/@testuser.ve-credentials.json').readAsStringSync(),
        previous);
  });
}
