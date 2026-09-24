import 'dart:isolate';

import 'package:at_policy/at_policy.dart';

class PolicyHandler implements PolicyRequestHandler {
  final SendPort sendPort;
  PolicyHandler(this.sendPort);

  @override
  Future<PolicyResponse> getPolicyDetails(PolicyRequest req) async {
    List<PolicyDetail> details = [];
    for (var intent in req.intents) {
      var detail = await handleIntent(req, intent);
      if (detail != null) {
        details.add(detail);
      }
    }
    return PolicyResponse(
      message: "${details.length}/${req.intents.length}"
          " intents approved for "
          "${req.clientAtsign} to ${req.serviceAtsign}",
      policyDetails: details,
    );
  }

  Future<PolicyDetail?> handleIntent(PolicyRequest req, PolicyIntent intent) async {
    return switch (intent.intent) {
      "request" => handleRequestIntent(req, intent),
      "access" => handleAccessIntent(req, intent),
      _ => null,
    };
  }

  Future<PolicyDetail?> handleRequestIntent(PolicyRequest req, PolicyIntent intent) async {
    if (intent.params == null) return null;
    Map<String, dynamic> payload = intent.params!;
    if (payload['atsign'] is! String && payload['color'] is! String) {
      return null;
    }
    int expiry = DateTime.now().millisecondsSinceEpoch + (30 * 60 * 1000); // 30 mins from now
    if (payload['expiry'] is int) {
      expiry = payload['expiry'];
    }
    if (payload['atsign'] is String) {}
    // TODO
  }

  Future<PolicyDetail?> handleAccessIntent(PolicyRequest req, PolicyIntent intent) async {
    // TODO
  }
}
