import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_share_request_service.dart';
import 'package:at_data_share/src/service/at_data_share_response_service.dart';
import 'package:at_utils/at_logger.dart';

class AtDataShareService {
  AtDataShareRequestService atDataShareRequestService =
      AtDataShareRequestService();

  AtDataShareResponseService atDataShareResponseService =
      AtDataShareResponseService();

  final logger = AtSignLogger('AtDataShareService');

  Future<void> init() async {
    AtClientManager.getInstance()
        .atClient
        .notificationService
        .subscribe()
        .listen((AtNotification atNotification) async {
      Map atNotificationMap = atNotification.toJson();
      if (atNotificationMap['id'] == '-1') {
        return;
      }
      String key = atNotificationMap['key'];
      if (key.contains('datasharerequest')) {
        await atDataShareRequestService.handleDataShareRequest(atNotification);
      } else if (key.contains('datashareresponse')) {
        await atDataShareResponseService
            .handleDataShareResponse(atNotification);
      } else {
        logger.info(atNotification);
      }
    });
  }
}
