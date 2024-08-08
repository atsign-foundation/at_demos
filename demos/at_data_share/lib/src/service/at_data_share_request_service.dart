import 'dart:convert';

import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_share_response_service.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/util/crud_operations.dart';
import 'package:at_utils/at_logger.dart';

class AtDataShareRequestService {
  final logger = AtSignLogger('AtDataShareRequestService');
  AtDataShareResponseService atDataShareResponseService =
      AtDataShareResponseService();
  CRUDOperations crudOperations = CRUDOperations();

  Future<NotificationResult> sendDataShareRequest(
      String sendRequestToAtSign, AtDataShareRequest atDataShareRequest) async {
    var notificationParams = NotificationParams.forText(
        atDataShareRequest.toString(), sendRequestToAtSign);

    String dataShareRequestKey =
        'datasharerequest_sent_${atDataShareRequest.requestId}_${atDataShareRequest.requestedToAtSign.replaceAll('@', '')}';
    await crudOperations.storeDataShareRequest(
        dataShareRequestKey, atDataShareRequest);

    NotificationResult notificationResult = await AtClientManager.getInstance()
        .atClient
        .notificationService
        .notify(notificationParams);
    logger.info(
        'Requesting data from $sendRequestToAtSign with requestId: ${atDataShareRequest.requestId}');
    return notificationResult;
  }

  Future<void> handleDataShareRequest(AtNotification atNotification) async {
    Map atNotificationMap = atNotification.toJson();
    String key = atNotificationMap['key'];

    key = key.substring(key.indexOf('_') + 1);
    AtDataShareRequest atDataShareRequest =
        AtDataShareRequest.fromJson(jsonDecode(key));

    String dataShareRequestKey =
        'datasharerequest_received_${atDataShareRequest.requestId}_${atDataShareRequest.requestedByAtSign}';
    await crudOperations.storeDataShareRequest(
        dataShareRequestKey, atDataShareRequest);
    // Send ACK to the request sender.
    await AtClientManager.getInstance().atClient.notificationService.notify(
        NotificationParams.forText(
            "ACK:${atDataShareRequest.requestId}", '@${atDataShareRequest.requestedByAtSign}'));
  }

  Future<List<AtDataShareRequest>> getReceivedDataShareRequests(
      {String requestId = ''}) async {
    String regex = 'datasharerequest_received_';
    if (requestId.isNotEmpty) {
      regex += requestId;
    }
    List<AtDataShareRequest> dataShareReceivedRequestsList = [];
    List<AtKey> dataShareReceivedRequestAtKeys =
        await AtClientManager.getInstance().atClient.getAtKeys(regex: regex);

    for (AtKey atKey in dataShareReceivedRequestAtKeys) {
      AtValue atValue = await AtClientManager.getInstance().atClient.get(atKey);
      atValue.value = atValue.value.substring(atValue.value.indexOf('_') + 1);
      AtDataShareRequest atDataShareRequest =
          AtDataShareRequest.fromJson(jsonDecode(atValue.value));
      dataShareReceivedRequestsList.add(atDataShareRequest);
    }
    return dataShareReceivedRequestsList;
  }

  Future<List<AtDataShareRequest>> getSentDataShareRequests() async {
    List<AtDataShareRequest> dataShareReceivedRequestsList = [];
    List<AtKey> dataShareReceivedRequestAtKeys =
        await AtClientManager.getInstance()
            .atClient
            .getAtKeys(regex: 'datasharerequest_sent_');

    for (AtKey atKey in dataShareReceivedRequestAtKeys) {
      AtValue atValue = await AtClientManager.getInstance().atClient.get(atKey);
      atValue.value = atValue.value.substring(atValue.value.indexOf('_') + 1);
      AtDataShareRequest atDataShareRequest =
          AtDataShareRequest.fromJson(jsonDecode(atValue.value));

      dataShareReceivedRequestsList.add(atDataShareRequest);
    }
    return dataShareReceivedRequestsList;
  }
}
