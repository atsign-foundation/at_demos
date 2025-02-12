import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:programmable_policy/src/constants.dart';

class Client {
  Client();

  final Random random = Random(DateTime.now().millisecondsSinceEpoch);

  // Set by run
  late AtClient atClient;
  late String atSign;
  late String policyAtsign;
  late String loggingAtsign;

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
    parser.addMultiOption(
      "color",
      help: "Color that this client supports (comma separated)",
    );
    return parser;
  }

  FutureOr<int> asMain(List<String> args) async {
    var parser = getArgParser();
    ArgResults results;
    String policyAtsign;
    String loggingAtsign;
    CLIBase cliBase;
    List<String> colors;
    try {
      cliBase = await CLIBase.fromCommandLineArgs(args, parser: parser);
      results = parser.parse(args);
      policyAtsign = results["policy-manager"];
      loggingAtsign = results["logging-atsign"] ?? policyAtsign;
      colors = results["color"] ?? [];
      if (colors.isEmpty) throw "No colors specified";
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
        colors: colors,
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
    required List<String> colors,
  }) {
    this.atSign = atSign;
    this.atClient = atClient;
    this.policyAtsign = policyAtsign;
    this.loggingAtsign = loggingAtsign;
    // var rpc = AtRpcClient(
    //   atClient: atClient,
    //   baseNameSpace: Constants.namespace,
    //   domainNameSpace: Constants.policyDomain,
    //   serverAtsign: policyAtsign,
    // );
    // make 1-10 requests
    int numReqs = random.nextInt(10) + 1;
    var policyClient = AtRpcClient(
      atClient: atClient,
      baseNameSpace: Constants.namespace,
      domainNameSpace: Constants.policyDomain,
      serverAtsign: policyAtsign,
    );
    // TODO
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
