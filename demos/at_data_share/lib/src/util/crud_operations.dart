import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/util/constants.dart';
import 'package:at_utils/at_logger.dart';

class CRUDOperations {
  final logger = AtSignLogger('CRUDOperations');

  Future<void> removeDataShareRequest(String key) async {
    logger.info('Deleting the key: $key');
    AtKey dataShareRequestAtKey = AtKey.self(key,
            namespace: Constants.namespace,
            sharedBy:
                AtClientManager.getInstance().atClient.getCurrentAtSign()!)
        .build();

    await AtClientManager.getInstance().atClient.delete(dataShareRequestAtKey);
  }

  Future<void> storeDataShareRequest(
      String key, AtDataShareRequest atDataShareRequest) async {
    logger.info('Storing key: $key');
    AtKey dataShareRequestAtKey = AtKey.self(key,
            namespace: Constants.namespace,
            sharedBy:
                AtClientManager.getInstance().atClient.getCurrentAtSign()!)
        .build();

    await AtClientManager.getInstance()
        .atClient
        .put(dataShareRequestAtKey, atDataShareRequest.toString());
  }
}
