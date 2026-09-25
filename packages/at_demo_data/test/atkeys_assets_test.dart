import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:at_demo_data/at_demo_data.dart' as demo;
import 'package:crypton/crypton.dart';
import 'package:encrypt/encrypt.dart';
import 'package:test/test.dart';

void main() {
  test('every VE Atsign has a matching atKeys asset', () {
    Set<String> atsigns = <String>{
      ...demo.allAtsigns.where((String atsign) => atsign != 'anonymous'),
      ...demo.apkamAtsigns,
    };
    Directory directory = Directory('lib/assets/atkeys');
    Set<String> assets = directory
        .listSync()
        .whereType<File>()
        .map((File file) => file.uri.pathSegments.last)
        .toSet();
    expect(assets, atsigns.map((String atsign) => '$atsign.atKeys').toSet());

    expect(demo.apkamPrivateKeyMap.keys.toSet(),
        demo.apkamPublicKeyMap.keys.toSet());
    expect(demo.apkamPublicKeyMap.keys.toSet().difference(atsigns), isEmpty);
    for (String atsign in demo.apkamPublicKeyMap.keys) {
      expect(
        RSAPrivateKey.fromString(demo.apkamPrivateKeyMap[atsign]!)
            .publicKey
            .toString(),
        demo.apkamPublicKeyMap[atsign],
        reason: '$atsign APKAM key pair',
      );
    }

    for (String atsign in atsigns) {
      Map<String, dynamic> keys = jsonDecode(
        File('${directory.path}/$atsign.atKeys').readAsStringSync(),
      ) as Map<String, dynamic>;
      expect(keys.keys.toSet(), <String>{
        'aesPkamPublicKey',
        'aesPkamPrivateKey',
        'aesEncryptPublicKey',
        'aesEncryptPrivateKey',
        'selfEncryptionKey',
        atsign,
      });
      expect(keys['selfEncryptionKey'], demo.aesKeyMap[atsign]);
      expect(base64Decode(keys[atsign] as String), hasLength(32));

      Encrypter decrypter = Encrypter(
        AES(Key.fromBase64(demo.aesKeyMap[atsign]!)),
      );
      IV iv = IV(Uint8List(16));
      Map<String, String> expected = <String, String>{
        'aesPkamPublicKey': demo.pkamPublicKeyMap[atsign]!,
        'aesPkamPrivateKey': demo.pkamPrivateKeyMap[atsign]!,
        'aesEncryptPublicKey': demo.encryptionPublicKeyMap[atsign]!,
        'aesEncryptPrivateKey': demo.encryptionPrivateKeyMap[atsign]!,
      };
      for (MapEntry<String, String> entry in expected.entries) {
        expect(
            decrypter.decrypt64(keys[entry.key] as String, iv: iv), entry.value,
            reason: '$atsign ${entry.key}');
      }
      expect(
        RSAPrivateKey.fromString(demo.pkamPrivateKeyMap[atsign]!)
            .publicKey
            .toString(),
        demo.pkamPublicKeyMap[atsign],
        reason: '$atsign PKAM key pair',
      );
      expect(
        RSAPrivateKey.fromString(demo.encryptionPrivateKeyMap[atsign]!)
            .publicKey
            .toString(),
        demo.encryptionPublicKeyMap[atsign],
        reason: '$atsign encryption key pair',
      );
    }
  });
}
