import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:newserverdemo/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Login test', () {
    var addKey = 'fullname';
    var addValue = 'Alice josephine';
    var atsign = '@alice🛠';
    var dropdownField = find.byKey(Key('dropdown'));
    var loginButton = find.byKey(Key('Login'));
    var keyField = find.byKey(Key('UpdateKey'));
    var valueField = find.byKey(Key('UpdateValue'));
    var updateButton = find.text('Update');
    var scanButton = find.byKey(Key('Scan'));
    var lookupButton = find.byKey(Key('LookupButton'));

    testWidgets('Log in to the app', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
    // tap on the dropdown
      await tester.tap(dropdownField);
      await tester.pump(Duration(seconds: 1));
    // select the atsign for authentication
      await tester.tap(find.text('$atsign').first);
      await tester.pump(Duration(seconds: 3));
      expect(loginButton, findsOneWidget);
      // Login to the application
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(keyField);
    // enter key to be updated
      await tester.enterText(keyField, '$addKey');
      await tester.tap(valueField);
    // enter the value to be updated
      await tester.enterText(valueField, '$addValue');
    // clicking update 
      await tester.tap(updateButton);
      await tester.pump(Duration(seconds: 1));
    // click scan 
      await tester.tap(scanButton);
      await tester.pump(Duration(seconds: 1));
    // select the scan dropdown
      await tester.tap(find.byKey(Key('scanDropdown')));
      await tester.pump(Duration(seconds: 3));
      await tester.tap(find.text('fullname').last);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 3));
      await tester.tap(lookupButton);
      await tester.pumpAndSettle();
      // expect the lookup value in the widget
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Text && widget.data == '$addValue'),
          findsOneWidget);
    });
  });
}
