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
