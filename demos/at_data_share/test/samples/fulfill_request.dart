import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_request_fulfillment.dart';
import 'package:at_data_share/src/service/at_data_share_request_service.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/spec/fulfillment_status.dart';
import 'package:at_data_share/src/util/constants.dart';
import 'package:at_data_share/src/util/crud_operations.dart';
import 'package:at_data_share/src/util/preferences_utils.dart';

void main() async {
  String atSign = '@bob';
  String namespace = Constants.namespace;
  AtClientPreference atClientPreference = getAtClientPreference();
  AtDataRequestFulfillment atDataRequestFulfillment =
      AtDataRequestFulfillment();
  CRUDOperations crudOperations = CRUDOperations();
  await AtClientManager.getInstance()
      .setCurrentAtSign(atSign, namespace, atClientPreference);

  AtDataShareRequestService atDataShareRequestService =
      AtDataShareRequestService();
  List<AtDataShareRequest> listOfReceivedRequests =
      await atDataShareRequestService.getReceivedDataShareRequests(
          requestId: '681667286');
  var fulfillmentStatus = await atDataRequestFulfillment
      .fulfillRequest(listOfReceivedRequests.first);

  if (fulfillmentStatus == FulfillmentStatus.completed) {
    String dataShareRequestKey =
        'datasharerequest_received_${listOfReceivedRequests.first.requestId}_${listOfReceivedRequests.first.requestedByAtSign.replaceAll('@', '')}';
    crudOperations.removeDataShareRequest(dataShareRequestKey);
  }
}
