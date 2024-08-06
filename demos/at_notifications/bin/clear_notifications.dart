import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_notifications/constants.dart';
import 'package:at_notifications/util.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:at_utils/at_utils.dart';

// dart run clear-notifications.dart -a @alice -v
void main(List<String> arguments) async {
    final ArgParser argParser = ArgParser();
    argParser.addOption('atsign', abbr: 'a', help: 'the atSign to clear notifications for', mandatory: true);
    argParser.addOption('namespace', abbr: 'n', help: 'namespace of the app', mandatory: false, defaultsTo: AtNotificationsDemoConstants.defaultNamespace);
    argParser.addFlag('verbose', abbr: 'v', help: 'more logging', negatable: true, defaultsTo: true);

    final ArgResults argResults = argParser.parse(arguments);

    late String atSign;
    late String namespace;
    late bool verbose;

    try {
        atSign = AtUtils.fixAtSign(argResults['atsign']);
        namespace = argResults['namespace'];
        verbose = argResults['verbose'];
    } catch (e) {
        stdout.writeln(argParser.usage);
        exit(1);
    }

    AtSignLogger.root_level = verbose ? 'warning' : 'info';

    final AtOnboardingPreference preference = AtNotificationsDemoUtil.generatePreference(atSign, namespace);

    final AtOnboardingService atOnboardingService = AtOnboardingServiceImpl(atSign, preference);
    final bool pkamAuthenticated = await atOnboardingService.authenticate();

    if(!pkamAuthenticated) {
        throw Exception('Unable to authenticate as $atSign');
    }

    stdout.writeln('Authenticated as $atSign');

    final AtClient atClient = atOnboardingService.atClient!;

    String? res = await atClient.getRemoteSecondary()!.executeCommand('notify:list\n', auth: true);

    if(res == null) {
        throw Exception('Unable to get notifications for $atSign');
    }

    if(res.startsWith('data:')) {
        res = res.substring(5);
    }
    
    if(res == '[]') {
        stdout.writeln('No notifications to clear');
        exit(0);
    }

    List<dynamic> json = jsonDecode(res) as List<dynamic>;

    for(int i = 0; i < json.length; i++) {
        final Map<String, dynamic> entry = json[i] as Map<String, dynamic>;
        final String id = entry['id'] as String;
        atClient.getRemoteSecondary()!.executeCommand('notify:remove:$id\n', auth: true).then((value) => stdout.writeln('Cleared notification $id | Response: $value')).onError((error, stackTrace) => stdout.writeln('Error clearing notification $id | Error: $error'));

    }
    
}