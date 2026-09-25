import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:test/test.dart';

void main() {
  group('at_demo_data credentials tests', () {
    test('allAtsigns exists', () {
      expect(
        at_demo_data.allAtsigns,
        allOf(
          <Matcher>[isNotNull, isNotEmpty, hasLength(greaterThan(0))],
        ),
      );
    });

    test('allAtsigns contains only lowercaee @signs', () {
      for (String atSign in at_demo_data.allAtsigns) {
        bool name = (atSign.toLowerCase() == atSign);
        expect(name, isTrue);
      }
    });

    test('only emoji-free Atsigns remain', () {
      for (String removedAtsign in <String>[
        '@colin',
        '@barbara',
        '@curtly',
        '@denise',
        '@don',
        '@gareth',
        '@gary',
        '@jeremy',
        '@xavier',
        '@chris',
        '@sachin',
        '@srie',
      ]) {
        expect(at_demo_data.allAtsigns, isNot(contains(removedAtsign)));
        expect(at_demo_data.cramKeyMap.containsKey(removedAtsign), isFalse);
      }
      for (String atsign in <String>[
        ...at_demo_data.allAtsigns,
        ...at_demo_data.apkamAtsigns,
      ]) {
        expect(atsign, matches(RegExp(r'^[\x00-\x7F]+$')));
      }
    });

    test('legacy and APKAM identities use separate VE setup paths', () {
      expect(at_demo_data.apkamAtsigns,
          unorderedEquals(<String>['@device2', '@cloudvm2']));
      expect(
          at_demo_data.allAtsigns,
          unorderedEquals(<String>[
            'anonymous',
            for (int number = 1; number <= 6; number++) '@relay$number',
            '@device1',
            for (int number = 3; number <= 6; number++) '@device$number',
            '@cloudvm1',
            '@gateway1',
            '@gateway2',
            for (int number = 1; number <= 2; number++) '@policy$number',
            for (int number = 1; number <= 2; number++) '@events$number',
            for (int number = 1; number <= 6; number++) '@client$number',
            '@telemetry1',
            '@telemetry2',
            for (int number = 1; number <= 6; number++) '@producer$number',
          ]));
      expect(
          at_demo_data.allAtsigns
              .toSet()
              .intersection(at_demo_data.apkamAtsigns.toSet()),
          isEmpty);
      for (String atsign in at_demo_data.apkamAtsigns) {
        expect(at_demo_data.cramKeyMap[atsign], isNotEmpty);
      }
      expect(
          at_demo_data.apkamPublicKeyMap.keys,
          containsAll(<String>[
            '@relay1',
            for (int number = 3; number <= 6; number++) '@relay$number',
            for (int number = 1; number <= 6; number++) '@client$number',
            for (int number = 1; number <= 2; number++) '@events$number',
          ]));
    });

    test('credentials are distinct for each Atsign', () {
      for (Map<String, String> credentials in <Map<String, String>>[
        at_demo_data.cramKeyMap,
        at_demo_data.pkamPublicKeyMap,
        at_demo_data.pkamPrivateKeyMap,
        at_demo_data.encryptionPublicKeyMap,
        at_demo_data.encryptionPrivateKeyMap,
        at_demo_data.aesKeyMap,
        at_demo_data.apkamSymmetricKeyMap,
      ]) {
        Iterable<String> values = credentials.values.where(
          (String value) => value.isNotEmpty,
        );
        expect(values.toSet(), hasLength(values.length));
      }
    });

    test('every active Atsign has a full credential set', () {
      Set<String> all = <String>{
        ...at_demo_data.allAtsigns,
        ...at_demo_data.apkamAtsigns,
      };
      Set<String> authenticated = all.difference(<String>{'anonymous'});
      for (Map<String, String> credentials in <Map<String, String>>[
        at_demo_data.cramKeyMap,
        at_demo_data.pkamPublicKeyMap,
        at_demo_data.pkamPrivateKeyMap,
        at_demo_data.encryptionPublicKeyMap,
        at_demo_data.encryptionPrivateKeyMap,
      ]) {
        expect(credentials.keys.toSet(), all);
      }
      for (Map<String, String> credentials in <Map<String, String>>[
        at_demo_data.aesKeyMap,
        at_demo_data.apkamSymmetricKeyMap,
      ]) {
        expect(credentials.keys.toSet(), authenticated);
      }
    });

    test('cramKeyMap exists', () {
      expect(
          at_demo_data.cramKeyMap,
          allOf(<Matcher>[
            isNotNull,
            isNotEmpty,
          ]));
    });

    test('cramKeyMap contains a value for each @sign', () {
      for (String atSign in at_demo_data.allAtsigns) {
        String? value = at_demo_data.cramKeyMap[atSign];
        expect(value, isNotNull);
      }
    });

    test('cramKeyMap contains an entry for each @sign', () {
      at_demo_data.cramKeyMap.forEach((String k, String v) {
        expect(v, isNotNull);
      });
    });
  });

  test('pkamPublicKeyMap exists', () {
    expect(
        at_demo_data.pkamPublicKeyMap,
        allOf(<Matcher>[
          isNotNull,
          isNotEmpty,
        ]));
  });

  test('pkamPrivateKeyMap exists', () {
    expect(
        at_demo_data.pkamPrivateKeyMap,
        allOf(<Matcher>[
          isNotNull,
          isNotEmpty,
        ]));
  });

  test('pkamPublicKeyMap contains a value for each @sign', () {
    for (String atSign in at_demo_data.allAtsigns) {
      String? value = at_demo_data.pkamPublicKeyMap[atSign];
      expect(value, isNotNull);
    }
  });

  test('pkamPrivateKeyMap contains a value for each @sign', () {
    for (String atSign in at_demo_data.allAtsigns) {
      String? value = at_demo_data.pkamPrivateKeyMap[atSign];
      expect(value, isNotNull);
    }
  });

  group('at_demo_data env tests', () {
    test('prod root exists', () {
      expect(
          at_demo_data.prodRoot,
          allOf(<Matcher>[
            isNotNull,
            isNotEmpty,
          ]));
    });

    test('prod port exists', () {
      expect(
          at_demo_data.prodPort,
          allOf(<Matcher>[
            isNotNull,
            greaterThan(0),
          ]));
    });

    test('virtual_env root exists', () {
      expect(
          at_demo_data.virtualRoot,
          allOf(<Matcher>[
            isNotNull,
            isNotEmpty,
          ]));
    });

    test('virtual_env port exists', () {
      expect(
          at_demo_data.virtualPort,
          allOf(<Matcher>[
            isNotNull,
            greaterThan(0),
          ]));
    });
  });
}
