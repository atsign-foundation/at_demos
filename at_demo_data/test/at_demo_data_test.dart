import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:test/test.dart';

void main() {
  group('at_demo_data credentials tests', ()
  {
    test('allAtsigns exists', () {
      expect(at_demo_data.allAtsigns, allOf([
        isNotNull,
        isNotEmpty,
        hasLength(greaterThan(0))
      ]));
    });

    test('allAtsigns contains only lowercaee @signs', () {
      at_demo_data.allAtsigns.forEach((atsign) {
        bool name = (atsign.toLowerCase() == atsign);
        expect(name, isTrue);
      });
    });

    test('cramKeyMap exists', () {
      expect(at_demo_data.cramKeyMap, allOf([
        isNotNull,
        isNotEmpty,
      ]));
    });

    test('cramKeyMap contains a value for each @sign', () {
      at_demo_data.allAtsigns.forEach((atSign) {
        var value = at_demo_data.cramKeyMap[atSign];
        expect(value, isNotNull);
      });
    });

    test('cramKeyMap contains an entry for each @sign', () {
      at_demo_data.cramKeyMap.forEach((k,v) {
        expect(v, isNotNull);
      });
    });
  });

  test('pkamPublicKeyMap exists', () {
    expect(at_demo_data.pkamPublicKeyMap, allOf([
      isNotNull,
      isNotEmpty,
    ]));
  });

  test('pkamPrivateKeyMap exists', () {
    expect(at_demo_data.pkamPrivateKeyMap, allOf([
      isNotNull,
      isNotEmpty,
    ]));
  });

  test('pkamPublicKeyMap contains a value for each @sign', () {
    at_demo_data.allAtsigns.forEach((atSign) {
      var value = at_demo_data.pkamPublicKeyMap[atSign];
      expect(value, isNotNull);
    });
  });

  test('pkamPrivateKeyMap contains a value for each @sign', () {
    at_demo_data.allAtsigns.forEach((atSign) {
      var value = at_demo_data.pkamPrivateKeyMap[atSign];
      expect(value, isNotNull);
    });
  });

  group('at_demo_data env tests', ()
  {
    test('prod root exists', () {
      expect(at_demo_data.prodRoot, allOf([
        isNotNull,
        isNotEmpty,
      ]));
    });

    test('prod port exists', () {
      expect(at_demo_data.prodPort, allOf([
        isNotNull,
        greaterThan(0),
      ]));
    });

    test('virtual_env root exists', () {
      expect(at_demo_data.virtualRoot, allOf([
        isNotNull,
        isNotEmpty,
      ]));
    });

    test('virtual_env port exists', () {
      expect(at_demo_data.virtualPort, allOf([
        isNotNull,
        greaterThan(0),
      ]));
    });

  });
}