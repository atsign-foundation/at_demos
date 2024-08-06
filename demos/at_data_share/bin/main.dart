import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_data_share/src/service/at_data_share_request_service.dart';
import 'package:at_data_share/src/service/at_data_share_service.dart';
import 'package:at_data_share/src/spec/at_data_share.dart';
import 'package:at_data_share/src/util/command_line_parser.dart';
import 'package:at_data_share/src/util/constants.dart';
import 'package:at_data_share/src/util/preferences_utils.dart';
import 'package:uuid/uuid.dart';

void main(List<String> arguments) async {
  CommandLineParser commandLineParser = CommandLineParser();
  var parser = commandLineParser.getParser();
  ArgResults argResults = commandLineParser.getParserResults(arguments, parser);
  String currentAtSign = argResults['atSign'];
  String requestToAtSign = '@bob';
  AtClientPreference atClientPreference = getAtClientPreference();
  await AtClientManager.getInstance()
      .setCurrentAtSign(currentAtSign, Constants.namespace, atClientPreference);
  AtDataShareService atDataShareService = AtDataShareService();
  await atDataShareService.init();

  if (argResults['dataShareType'].toString().toLowerCase() == 'receivedata') {
    print('Waiting to server request');
    await Future.delayed(Duration(minutes: 5));
  }
  if (argResults['dataShareType'].toString().toLowerCase() == 'requestdata') {
    String uniqueId = Uuid().v4();
    AtDataShareRequest atDataShareRequest = AtDataShareRequest();
    AtDataShareRequestService atDataShareRequestService =
        AtDataShareRequestService();
    atDataShareRequest
      ..requestId = uniqueId.hashCode.toString()
      ..jsonSchema = {'firstname': ''}
      ..requestedByAtSign = currentAtSign
      ..requestedToAtSign = requestToAtSign
      ..via = Via.notification;
    var notificationResult = await atDataShareRequestService
        .sendDataShareRequest(requestToAtSign, atDataShareRequest);
    print(notificationResult.notificationID);
  }
}
