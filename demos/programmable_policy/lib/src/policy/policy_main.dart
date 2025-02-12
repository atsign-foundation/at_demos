import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_policy/at_policy.dart';
import 'package:programmable_policy/src/constants.dart';
import 'package:programmable_policy/src/policy/policy_handler.dart';
import 'package:programmable_policy/src/policy/policy_service.dart';
import 'package:programmable_policy/src/util.dart';

Future<void> policyMain(ReceivePort recvPort, SendPort sendPort) async {
  CLIBase? base;
  PolicyService? policy;
  PolicyHandler handler = PolicyHandler(sendPort);

  recvPort.listen((data) async {
    if (data is! String) return;
    var command = data.split(":").first;
    var payload = data.replaceFirst("$command:", "");

    // must login before doing anything else
    if (command != "login" && base == null) return;

    try {
      switch (command) {
        case "login":
          base ??= await handleLogin(payload);
          if (base != null) {
            policy = getPolicyService(base!.atClient, handler);
            unawaited(policy!.run());
          }
          break;
        default:
          break;
      }
    } catch (e) {
      sendLogMessage(sendPort, base?.atSign ?? "policyNoAuth", e.toString());
    }
  });
}

Future<CLIBase?> handleLogin(String payload) async {
  try {
    Map<String, dynamic> json = jsonDecode(payload);
    var atsign = json['atSign'];
    var keys = json['atKeysFile'];
    var storage = json['storageDir'];
    if (atsign is! String || keys is! String || storage is! String) {
      return null;
    }

    var base = CLIBase(
      atSign: atsign,
      nameSpace: Constants.namespace,
      rootDomain: Constants.rootDomain,
      atKeysFilePath: keys,
      homeDir: storage,
    );
    await base.init();
    return base;
  } catch (e) {
    return null;
  }
}
