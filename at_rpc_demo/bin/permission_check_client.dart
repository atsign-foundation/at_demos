import 'dart:async';
import 'dart:io';

import 'package:at_cli_commons/at_cli_commons.dart';
import 'package:at_client/at_client.dart';
import 'package:chalkdart/chalk.dart';

void main(List<String> args) async {
  var argsParser = CLIBase.argsParser
    ..addOption('server-atsign',
        mandatory: true, help: "the atSign of the RPC server");

  try {
    var serverAtsign = argsParser.parse(args)['server-atsign'];

    var atClient = (await CLIBase.fromCommandLineArgs(args)).atClient;

    var rpcClient = AtRpcClient(
        atClient: atClient,
        baseNameSpace: atClient.getPreferences()!.namespace!,
        domainNameSpace: 'at_rpc_permission_check_demo',
        serverAtsign: serverAtsign);

    stdout.writeln('This program will send a request to the'
        ' server asking, "can I send messages to @someAtSign?"'
        ' The server will respond with true or false');
    stdout.writeln('Server should be listening at'
        ' ${rpcClient.rpc.domainNameSpace}'
        '.${rpcClient.rpc.rpcsNameSpace}'
        '.${rpcClient.rpc.baseNameSpace}'
        '$serverAtsign');

    while (true) {
      stdout.writeln();
      stdout.write(chalk.brightBlue('enter an atSign : '));
      String? otherAtSign;
      while (otherAtSign == null) {
        otherAtSign = stdin.readLineSync();
      }
      if (!otherAtSign.startsWith('@')) {
        otherAtSign = '@$otherAtSign';
      }
      otherAtSign = otherAtSign.toLowerCase();

      try {
        stdout.write(chalk.brightBlue('Sending ... '));
        var response = await rpcClient.call({
          'reqType': 'canSendTo',
          'targetAtSign': otherAtSign
        }).timeout(Duration(seconds: 10));
        stdout.writeln(chalk.green(response));
      } on TimeoutException {
        stderr.writeln(chalk.brightRed('timed out waiting for response'));
      } catch (e) {
        stderr.writeln(chalk.brightRed(e));
      }
    }
  } catch (e) {
    print(e);
    print(argsParser.usage);
  }
}
