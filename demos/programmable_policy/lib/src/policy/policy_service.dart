import 'package:at_client/at_client.dart';
import 'package:at_policy/at_policy.dart';
import 'package:programmable_policy/src/constants.dart';
import 'package:programmable_policy/src/policy/policy_handler.dart';

PolicyService getPolicyService(AtClient atClient, PolicyHandler policyHandler) {
  return PolicyService(
    atClient: atClient,
    baseNamespace: Constants.namespace,
    loggingAtsign: atClient.getCurrentAtSign()!,
    allowList: {},
    allowAll: true,
    handler: policyHandler,
  );
}
