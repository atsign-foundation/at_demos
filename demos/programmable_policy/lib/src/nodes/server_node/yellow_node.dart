import 'dart:math';

import 'server_node.dart';

class YellowNode extends ServerNode {
  @override
  final String color = "yellow";

  @override
  final String description = "prng iot device stats";

  Random rng = Random(DateTime.now().millisecondsSinceEpoch);

  @override
  Future<AtRpcResp> handleRequest(AtRpcReq request, String fromAtSign) async {
    double temp = rng.nextDouble() * 60 - 30; // -30 to 30 degrees
    double humidity = rng.nextDouble();

    sendLogMessage("client: $fromAtSign - data requested, sending temp: $temp, humidity: $humidity");
    return AtRpcResp(
      reqId: request.reqId,
      respType: AtRpcRespType.success,
      payload: {'temp': temp, 'humidity': humidity},
    );
  }

  @override
  Future<void> handleResponse(AtRpcResp response) async {
    return;
  }
}
