import 'dart:convert';

import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/spec/fulfillment_status.dart';
import 'package:at_data_share/src/util/crud_operations.dart';
import 'package:at_utils/at_logger.dart';

class AtDataShareResponseService {
  final logger = AtSignLogger('AtDataShareResponseService');
  CRUDOperations crudOperations = CRUDOperations();

  Future<FulfillmentStatus> sendDataShareResponse(String sendResponseToAtSign,
      AtDataShareResponse atDataShareResponse) async {
    atDataShareResponse.senderAtSign =
        atDataShareResponse.senderAtSign.replaceAll('@', '');
    logger.info('Sending response to $sendResponseToAtSign');
    NotificationParams notificationParams = NotificationParams.forText(
        atDataShareResponse.toString(),
        AtClientUtil.fixAtSign(sendResponseToAtSign)!);

    NotificationResult notificationResult = await AtClientManager.getInstance()
        .atClient
        .notificationService
        .notify(notificationParams);
    logger.info('Sending response status | $notificationResult');
    if (notificationResult.notificationStatusEnum ==
        NotificationStatusEnum.delivered) {
      return FulfillmentStatus.completed;
    }
    return FulfillmentStatus.failed;
  }

  handleDataShareResponse(AtNotification atNotification) async {
    logger.info('Received response : $atNotification');
    Map atNotificationMap = atNotification.toJson();
    Map atDataShareResponse =
        jsonDecode(atNotificationMap['key'].split("_")[1]);
    String dataShareRequestKey =
        'datasharerequest_sent_${atDataShareResponse['responseId']}_${atDataShareResponse['senderAtSign']}';
    await crudOperations.removeDataShareRequest(dataShareRequestKey);
  }
}
