import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_share_response_service.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/spec/fulfillment_status.dart';
import 'package:at_data_share/src/util/constants.dart';
import 'package:at_utils/at_logger.dart';

class AtDataRequestFulfillment {
  final logger = AtSignLogger('AtDataRequestFulfillment');

  AtDataShareResponseService atDataShareResponseService =
      AtDataShareResponseService();

  Future<FulfillmentStatus> fulfillRequest(AtDataShareRequest atDataShareRequest) async {
    // Send Request to a fake App
    AtDataShareResponse atDataShareResponse = await dataShareRequestProcessor(
        atDataShareRequest.requestedToAtSign, atDataShareRequest);

    return await atDataShareResponseService.sendDataShareResponse(
        atDataShareRequest.requestedByAtSign, atDataShareResponse);
  }

  // Mocking the Response from APP.
  Future<AtDataShareResponse> dataShareRequestProcessor(
      String responseFromAtSign, AtDataShareRequest atDataShareRequest) async {
    AtDataShareResponse atDataShareResponse = AtDataShareResponse()
      ..responseId = atDataShareRequest.requestId
      ..senderAtSign = responseFromAtSign;

    Map<String, dynamic> requestedKeys = atDataShareRequest.jsonSchema;
    for (String key in requestedKeys.keys) {
      if (key.isNull) {
        continue;
      }
      AtKey atKey = (AtKey.shared(key,
              namespace: Constants.namespace,
              sharedBy:
                  AtClientManager.getInstance().atClient.getCurrentAtSign()!)
            ..sharedWith(
                AtClientUtil.fixAtSign(atDataShareRequest.requestedByAtSign)!))
          .build();
      logger.info('Received key: $atKey');
      AtValue atValue = await AtClientManager.getInstance().atClient.get(atKey);
      requestedKeys[key] = atValue.value;
    }
    atDataShareResponse.jsonSchema = requestedKeys;
    return atDataShareResponse;
  }
}
