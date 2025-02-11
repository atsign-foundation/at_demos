import 'dart:async';

import 'server_node.dart';

class RedNode extends ServerNode {
  @override
  final String color = "red";

  @override
  final String description = "ping-pong atrpc server";

  @override
  Future<AtRpcResp> handleRequest(AtRpcReq request, String fromAtSign) async {
    if (request.payload["message"] != "ping") {
      String logMessage = 'Invalid request, expected "message" to be ping';
      sendLogMessage("client: $fromAtSign - $logMessage");
      return AtRpcResp(
        reqId: request.reqId,
        respType: AtRpcRespType.error,
        payload: {},
        message: logMessage,
      );
    }
    sendLogMessage("client: $fromAtSign - received ping, sending pong");
    return AtRpcResp(
      reqId: request.reqId,
      respType: AtRpcRespType.error,
      payload: {'message': 'pong'},
    );
  }

  @override
  Future<void> handleResponse(AtRpcResp response) async {
    return;
  }
}
