import 'package:string_equation/string_equation.dart';

import 'server_node.dart';

class OrangeNode extends ServerNode {
  @override
  final String color = "orange";

  @override
  final String description = "basic calculator server";

  @override
  Future<AtRpcResp> handleRequest(AtRpcReq request, String fromAtSign) async {
    dynamic result;
    String? expression = request.payload["expression"];
    if (expression != null) {
      try {
        result = ConditionEquation().evaluateExpression(expression);
      } catch (_) {}
    }
    if (result == null) {
      String logMessage = 'Invalid math expression';
      sendLogMessage("client: $fromAtSign - $logMessage");
      return AtRpcResp(
        reqId: request.reqId,
        respType: AtRpcRespType.error,
        payload: {},
        message: logMessage,
      );
    }
    sendLogMessage("client: $fromAtSign - received expression: $expression, sending result: ${result.toString()}");
    return AtRpcResp(
      reqId: request.reqId,
      respType: AtRpcRespType.success,
      payload: {'result': result.toString()},
    );
  }

  @override
  Future<void> handleResponse(AtRpcResp response) async {
    return;
  }
}
