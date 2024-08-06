import 'dart:async';
import 'dart:io';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:chalkdart/chalk.dart';

void main(List<String> args) async {
  var argsParser = CLIBase.argsParser
    ..addOption('allow-list',
        mandatory: true,
        help:
            "comma-separated list of atSigns from which we will accept requests");

  try {
    var allowList =
        argsParser.parse(args)['allow-list'].toString().split(',').toSet();

    var atClient = (await CLIBase.fromCommandLineArgs(args)).atClient;

    var rpc = AtRpc(
      atClient: atClient,
      baseNameSpace: atClient.getPreferences()!.namespace!,
      domainNameSpace: 'at_rpc_permission_check_demo',
      callbacks: DemoRpcServer(),
      allowList: allowList,
    );

    stdout.writeln(chalk.blue('Server started, listening on'
        ' ${rpc.domainNameSpace}'
        '.${rpc.rpcsNameSpace}'
        '.${rpc.baseNameSpace}'
        '${rpc.atClient.getCurrentAtSign()}'));

    rpc.start();
  } catch (e) {
    print(e);
    print(argsParser.usage);
  }
}

class DemoRpcServer implements AtRpcCallbacks {
  @override
  Future<AtRpcResp> handleRequest(AtRpcReq request, String fromAtSign) async {
    stdout.writeln(chalk.blue('Received request ${request.toJson()}'));
    try {
      var reqType = request.payload['reqType'];
      switch (reqType) {
        case 'canSendTo':
          return await handleCanSendTo(request);
        default:
          var resp = AtRpcResp(
              reqId: request.reqId,
              respType: AtRpcRespType.error,
              message: 'Unknown request type: $reqType',
              payload: {'result': false});
          stdout.writeln(chalk.red('Sending response ${resp.toJson()}'));
          return resp;
      }
    } catch (e) {
      var resp = AtRpcResp(
        reqId: request.reqId,
        respType: AtRpcRespType.error,
        message: 'Permission check failed: $e',
        payload: {'result': false},
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

  Future<AtRpcResp> handleCanSendTo(AtRpcReq request) async {
    var targetAtSign = request.payload['targetAtSign'];
    if (targetAtSign == null) {
      var resp = AtRpcResp(
          reqId: request.reqId,
          respType: AtRpcRespType.error,
          message: 'targetAtSign must be provided in "canSendTo" checks',
          payload: {'result': false});
      stdout.writeln(chalk.red('Sending response ${resp.toJson()}'));
      return resp;
    } else {
      // TODO This is where you would insert some actual business logic.
      // Right now for demo purposes, this server will return 'true' if the
      // targetAtSign begins with '@c', and false for everything else
      var resp = AtRpcResp(
        reqId: request.reqId,
        respType: AtRpcRespType.success,
        payload: {'result': targetAtSign.toString().startsWith('@c')},
      );
      stdout.writeln(chalk.green('Sending response ${resp.toJson()}'));
      return resp;
    }
  }
}
