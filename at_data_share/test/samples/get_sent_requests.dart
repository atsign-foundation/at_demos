import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_share_request_service.dart';
import 'package:at_data_share/src/util/constants.dart';
import 'package:at_data_share/src/util/preferences_utils.dart';

void main() async {
  String atSign = '@alice';
  String namespace = Constants.namespace;
  AtClientPreference atClientPreference = getAtClientPreference();
  await AtClientManager.getInstance()
      .setCurrentAtSign(atSign, namespace, atClientPreference);

  AtDataShareRequestService atDataShareRequestService =
      AtDataShareRequestService();

  var listOfSentRequests =
      await atDataShareRequestService.getSentDataShareRequests();
  print(listOfSentRequests);
}
