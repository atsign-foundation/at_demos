import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_share_request_service.dart';
import 'package:at_data_share/src/service/at_data_share_service.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/util/constants.dart';
import 'package:at_data_share/src/util/preferences_utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('A test verify send data share request', () async {
      String currentAtSign = '@sitaram';
      AtClientPreference atClientPreference = getAtClientPreference();
      await AtClientManager.getInstance().setCurrentAtSign(
          currentAtSign, Constants.namespace, atClientPreference);
      AtDataShareService atDataShareService = AtDataShareService();
      await atDataShareService.init();
      AtDataShareRequest atDataShareRequest = AtDataShareRequest();
      AtDataShareRequestService atDataShareRequestService =
          AtDataShareRequestService();
      atDataShareRequest
        ..requestId = '123'
        ..jsonSchema = {'firstname': ''}
        ..requestedByAtSign = 'sitaram'
        ..via = Via.notification;
      var notificationResult = await atDataShareRequestService
          .sendDataShareRequest('@murali', atDataShareRequest);
      print(notificationResult.notificationID);
    });
  });
}
