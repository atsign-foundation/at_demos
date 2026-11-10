import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:at_policy/at_policy.dart';
import 'package:meta/meta.dart';
import 'package:programmable_policy/src/constants.dart';

export 'package:at_client/at_client.dart' show AtClient, AtRpcReq, AtRpcResp, AtRpcRespType;
export 'dart:async' show FutureOr;
export 'package:args/args.dart' show ArgParser, ArgResults;

abstract class ServerNode implements AtRpcCallbacks {
  ServerNode();

  String get color;
  String get description;

  // Set by run
  late AtClient atClient;
  late String atSign;
  late String policyAtsign;
  late String loggingAtsign;
  late AtRpcClient policyClient;

  @mustCallSuper
  ArgParser getArgParser() {
    ArgParser parser = ArgParser();
    parser.addOption(
      "policy-manager",
      abbr: "p",
      help: "Policy manager (atSign)",
      mandatory: true,
    );
    parser.addOption(
      "logging-atsign",
      abbr: "l",
      help: "Atsign for logging (if omitted, uses the policy manager)",
      mandatory: false,
    );
    return parser;
  }

  void handleArgResults(ArgResults results) {}

  FutureOr<int> asMain(List<String> args) async {
    var parser = getArgParser();
    ArgResults results;
    String policyAtsign;
    String loggingAtsign;
    CLIBase cliBase;
    try {
      cliBase = await CLIBase.fromCommandLineArgs(args, parser: parser);
      results = parser.parse(args);
      policyAtsign = results["policy-manager"];
      loggingAtsign = results["logging-atsign"] ?? policyAtsign;
      handleArgResults(results);
    } catch (e) {
      stderr.writeln("Failed to start the program: $e");
      return 1;
    }

    try {
      await run(
        atClient: cliBase.atClient,
        atSign: cliBase.atSign,
        policyAtsign: policyAtsign,
        loggingAtsign: loggingAtsign,
      );
      return 0;
    } catch (e, st) {
      stderr.writeln("Program crashed: $e");
      stderr.writeln("Stack Trace: $st");
      return 2;
    }
  }

  FutureOr<void> run({
    required AtClient atClient,
    required String atSign,
    required String policyAtsign,
    required String loggingAtsign,
  }) {
    this.atSign = atSign;
    this.atClient = atClient;
    this.policyAtsign = policyAtsign;
    this.loggingAtsign = loggingAtsign;
    policyClient = AtRpcClient(
      atClient: atClient,
      baseNameSpace: Constants.namespace,
      domainNameSpace: Constants.policyDomain,
      serverAtsign: policyAtsign,
    );

    var thisServer = AtRpc(
      atClient: atClient,
      baseNameSpace: Constants.namespace,
      domainNameSpace: color,
      callbacks: this,
      allowList: {},
      allowAll: true,
    );

    thisServer.start();
  }

  Future<AtRpcReq?> checkPolicy(AtRpcReq request, String fromAtSign) async {
    PolicyRequest polReq = PolicyRequest(
        serviceAtsign: atSign,
        serviceName: "${atSign.substring(1)}_$color",
        serviceGroupName: color,
        clientAtsign: fromAtSign,
        intents: [
          PolicyIntent(intent: "access", params: {}),
        ]);
    Map<String, dynamic> policyResponse = await policyClient.call(polReq.toJson());
    if (policyResponse["granted"] is bool && policyResponse["granted"] == true) {
      return null;
    }
    // return AtRpcResp(
    //   // TODO
    // );
  }

  Future<void> sendLogMessage(String message) async {
    var keyBuilder = AtKey.shared(
      "log",
      namespace: "${Constants.loggingDomain}.${Constants.namespace}",
      sharedBy: atSign,
    )..sharedWith(loggingAtsign);

    atClient.notificationService.notify(
      NotificationParams.forUpdate(
        keyBuilder.build(),
        value: message,
      ),
    );
  }
}
