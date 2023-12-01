import 'dart:async';
import 'dart:io';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:chalkdart/chalk.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main(List<String> args) async {
  try {
    var argsParser = CLIBase.argsParser
      ..addOption('allow-list',
          mandatory: true,
          help: "comma-separated list of atSigns from which we will accept requests");

    var allowList = argsParser.parse(args)['allow-list'].toString().split(',').toSet();

    var atClient = (await CLIBase.fromCommandLineArgs(args)).atClient;

    var rpc = AtRpc(
      atClient: atClient,
      baseNameSpace: atClient.getPreferences()!.namespace!,
      domainNameSpace: 'at_rpc_demo',
      callbacks: DemoRpcServer(),
      allowList: allowList,
    );

    rpc.start();
  } catch (e) {
    print(e);
    print(CLIBase.argsParser.usage);
  }
}

class DemoRpcServer implements AtRpcCallbacks {
  final Parser p = Parser();
  final ContextModel _cm = ContextModel()..bindVariable(Variable('pi'), Number(math.pi));

  @override
  Future<AtRpcResp> handleRequest(AtRpcReq request, String fromAtSign) async {
    stdout.writeln(chalk.blue('Received request ${request.toJson()}'));
    Expression exp = p.parse(request.payload['expr']);
    try {
      var result = exp.evaluate(EvaluationType.REAL, _cm);
      var resp = AtRpcResp(
        reqId: request.reqId,
        respType: AtRpcRespType.success,
        payload: {'result': result},
      );
      stdout.writeln(chalk.green('Sending response ${resp.toJson()}'));
      return resp;
    } catch (e) {
      var resp = AtRpcResp(
        reqId: request.reqId,
        respType: AtRpcRespType.error,
        message: 'Failed to evaluate: $e',
        payload: {'result': 'FAIL'},
      );
      stdout.writeln(chalk.red('Sending response ${resp.toJson()}'));
      return resp;
    }
  }

  @override
  Future<void> handleResponse(AtRpcResp response) async {
    // Not expecting to receive responses
    throw UnimplementedError();
  }
}
