

import 'dart:io';

import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_notifications/util.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:at_utils/at_utils.dart';

void main(List<String> arguments) async {
	final ArgParser argParser = ArgParser();
    argParser.addOption('from', abbr: 'f', help: 'the subscriber', mandatory: true);
    argParser.addOption('to', abbr: 't', help: 'the notifier', mandatory: true);
    argParser.addOption('namespace', abbr: 'n', help: 'namespace of the app', mandatory: false, defaultsTo: 'at_notifications_demo');
    argParser.addOption('regex', abbr: 'r', help: 'the regex to filter notifications with', mandatory: false, defaultsTo: '.*');
    argParser.addFlag('verbose', abbr: 'v', help: 'more logging', negatable: true, defaultsTo: false);
    argParser.addFlag('subscribetonotifier', abbr: 'z', help: 'subscribe strictly to notifications from the notifier', negatable: true, defaultsTo: true);
    argParser.addFlag('decrypt', abbr: 'd', help: 'should decrypt notifications', negatable: true, defaultsTo: true);

    late ArgResults argResults;

    try {
        argResults = argParser.parse(arguments);
    } catch (e) {
        stdout.writeln(argParser.usage);
    }

    final String subscriber = AtUtils.fixAtSign(argResults['from']);
    final String notifier = AtUtils.fixAtSign(argResults['to']);
    final String namespace = argResults['namespace'];
    String regex = argResults['regex'];
    final bool verbose = argResults['verbose'];
    final bool subscribeToNotifier = argResults['subscribetonotifier'];
    final bool shouldDecrypt = argResults['decrypt'];

    //                           | subscribeToNotifier | subscribeToNotifier
    //                           | true                | false
    // --------------------------|---------------------|---------------
    // regex provided true       | use regex provided  | use regex provided 
    // regex provided false      | '${notifier}'       | '.*'
    
    if(subscribeToNotifier && regex == '.*') {
        regex = notifier;
    }

    AtSignLogger.root_level = verbose ? 'info' : 'warning';

    final AtOnboardingPreference preference = AtNotificationsDemoUtil.generatePreference(subscriber, namespace);

    final AtOnboardingService atOnboardingService = AtOnboardingServiceImpl(subscriber, preference);
    final bool pkamAutheneticated = await atOnboardingService.authenticate();

    if(!pkamAutheneticated) {
        throw Exception('Unable to authenticate $subscriber');
    }

    stdout.writeln('Authenticated as $subscriber');

    final AtClient atClient = atOnboardingService.atClient!;

    final NotificationService notificationService = atClient.notificationService;

    final Stream<AtNotification> stream = notificationService.subscribe(
        regex: regex, 
        shouldDecrypt: shouldDecrypt
    );

    stream.listen((AtNotification atNotification) {
        _printAtNotification(atNotification);
    });

    stdout.writeln('Subscribed to notifications from "$notifier" with regex "$regex"');

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