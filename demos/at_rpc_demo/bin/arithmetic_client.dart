import 'dart:async';
import 'dart:io';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:chalkdart/chalk.dart';

void main(List<String> args) async {
  try {
    var argsParser = CLIBase.argsParser
      ..addOption('server-atsign',
          mandatory: true,
          help: "the atSign of the RPC server");

    var serverAtsign = argsParser.parse(args)['server-atsign'];

    var atClient = (await CLIBase.fromCommandLineArgs(args)).atClient;

    var rpc = AtRpcClient(
        atClient: atClient,
        baseNameSpace: atClient.getPreferences()!.namespace!,
        domainNameSpace: 'at_rpc_arithmetic_demo',
        serverAtsign: serverAtsign);

    stdout.writeln('Sends input to an rpc server which will'
        ' attempt to evaluate it as a math expression');
    stdout.writeln();
    while (true) {
      stdout.write(chalk.brightBlue('enter math expression: '));
      var expr = stdin.readLineSync();
      if (expr == null || expr == 'exit' || expr == 'quit') {
        break;
      }
      try {


        var response = await rpc.call({'expr': expr}).timeout(Duration(seconds: 5));


        stdout.writeln(chalk.green(response));
      } on TimeoutException {
        stderr.writeln(chalk.brightRed('timed out waiting for response'));
      } catch (e) {
        stderr.writeln(chalk.brightRed(e));
      }
    }
    exit(0);
  } catch (e) {
    print(e);
    print(CLIBase.argsParser.usage);
  }
}
