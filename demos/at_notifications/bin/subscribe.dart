


import 'dart:io';

import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_notifications/constants.dart';
import 'package:at_notifications/util.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:at_utils/at_utils.dart';

// subscriber: @subscriber
// notifier: @notifier
// dart run subscribe-to-notifier.dart -f @subscriber -t @notifier
void main(List<String> arguments) async {
	final ArgParser argParser = ArgParser();
    argParser.addOption('atsign', abbr: 'a', help: 'atSign listening for notifications', mandatory: true);
    argParser.addOption('regex', abbr: 'r', help: 'the regex to filter notifications with', mandatory: false, defaultsTo: AtNotificationsDemoConstants.defaultRegex);
    argParser.addOption('namespace', abbr: 'n', help: 'namespace of the app', mandatory: false, defaultsTo: AtNotificationsDemoConstants.defaultNamespace);
    argParser.addFlag('decrypt', abbr: 'd', help: 'should decrypt notifications', negatable: true, defaultsTo: AtNotificationsDemoConstants.defaultShouldDecrypt);
    argParser.addFlag('showstats', abbr: 's', help: 'shows stats notifications', negatable: true, defaultsTo: false);
    argParser.addFlag('verbose', abbr: 'v', help: 'more logging', negatable: true, defaultsTo: AtNotificationsDemoConstants.defaultVerbose);

    final ArgResults argResults = argParser.parse(arguments);

    late String atSign;
    late String regex;
    late String namespace;
    late bool shouldDecrypt;
    late bool showStats;
    late bool verbose;

    try {
        atSign = AtUtils.fixAtSign(argResults['atsign']);
        regex = argResults['regex'];
        namespace = argResults['namespace'];
        shouldDecrypt = argResults['decrypt'];
        showStats = argResults['showstats'];
        verbose = argResults['verbose'];
    } catch (e) {
        stdout.writeln(argParser.usage);
        stdout.writeln(e);
        exit(0);
    }

    AtSignLogger.root_level = verbose ? 'info' : 'warning';

    final AtOnboardingPreference preference = AtNotificationsDemoUtil.generatePreference(atSign, namespace);

    final AtOnboardingService atOnboardingService = AtOnboardingServiceImpl(atSign, preference);
    final bool pkamAuthenticated = await atOnboardingService.authenticate();

    if(!pkamAuthenticated) {
        throw Exception('Unable to authenticate $atSign');
    }

    stdout.writeln('Authenticated as $atSign');

    final AtClient atClient = atOnboardingService.atClient!;

    final NotificationService notificationService = atClient.notificationService;

    final Stream<AtNotification> stream = notificationService.subscribe(
        regex: regex, 
        shouldDecrypt: shouldDecrypt
    );

    stream.listen((AtNotification atNotification) {
        if(!showStats || atNotification.id != '-1') {
            _printAtNotification(atNotification);
        }
    });

    stdout.writeln('Listening for notifications with regex "$regex"');

}

void _printAtNotification(AtNotification atNotification) {
    final String id = atNotification.id;
    final String key = atNotification.key;
    final String from = atNotification.from;
    final String to = atNotification.to;
    final int epochMillis = atNotification.epochMillis;
    final String status = atNotification.status;
    final String? value = atNotification.value;
    final String? operation = atNotification.operation;
    final String? messageType = atNotification.messageType;
    final bool? isEncrypted = atNotification.isEncrypted;
    final int? expiresAtInEpochMillis = atNotification.expiresAtInEpochMillis;
    final Metadata? metadata = atNotification.metadata;

    stdout.writeln();
    stdout.writeln('[NOTIFICATION RECEIVED] =>');
    stdout.writeln('\tid: $id');
    stdout.writeln('\tkey: $key');
    stdout.writeln('\tfrom: $from');
    stdout.writeln('\tto: $to');
    stdout.writeln('\tepochMillis: $epochMillis');
    stdout.writeln('\tstatus: $status');
    stdout.writeln('\tvalue: $value');
    stdout.writeln('\toperation: $operation');
    stdout.writeln('\tmessageType: $messageType');
    stdout.writeln('\tisEncrypted: $isEncrypted');
    stdout.writeln('\texpiresAtInEpochMillis: $expiresAtInEpochMillis');
    stdout.writeln('\tmetadata: $metadata');
}