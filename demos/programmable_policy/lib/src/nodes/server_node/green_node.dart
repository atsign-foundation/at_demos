import 'dart:math';

import 'server_node.dart';

class GreenNode extends ServerNode {
  @override
  final String color = "green";

  @override
  final String description = "dice rolling server";

  Random rng = Random(DateTime.now().millisecondsSinceEpoch);
  int diceSize = 6;

  @override
  ArgParser getArgParser() {
    var parser = super.getArgParser();
    parser.addOption("dice-size");
    return parser;
  }

  @override
  void handleArgResults(ArgResults results) {
    if (results['dice-size'] is String) {
      var newSize = int.tryParse(results['dice-size']);
      if (newSize is int && newSize > 0) {
        diceSize = newSize;
      }
    }
  }

  @override
  Future<AtRpcResp> handleRequest(AtRpcReq request, String fromAtSign) async {
    int roll = rng.nextInt(diceSize) + 1;
    sendLogMessage("client: $fromAtSign - rolling dice, sending result: $roll");
    return AtRpcResp(
      reqId: request.reqId,
      respType: AtRpcRespType.success,
      payload: {'result': roll},
    );
  }

  @override
  Future<void> handleResponse(AtRpcResp response) async {
    return;
  }
}
