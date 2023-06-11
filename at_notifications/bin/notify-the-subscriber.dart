

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
    argParser.addOption('message', abbr: 'm', help: 'the message to send', mandatory: false, defaultsTo: 'Hello, World!');
    argParser.addOption('namespace', abbr: 'n', help: 'namespace of the app', mandatory: false, defaultsTo: 'at_notifications_demo');
    argParser.addFlag('verbose', abbr: 'v', help: 'more logging', negatable: true, defaultsTo: false);

    late ArgResults argResults;

    try {
        argResults = argParser.parse(arguments);
    } catch (e) {
        stdout.writeln(argParser.usage);
    }

    final String notifier = AtUtils.fixAtSign(argResults['from']);
    final String subscriber = AtUtils.fixAtSign(argResults['to']);
    final String message = argResults['message'];
    final String namespace = argResults['namespace'];
    final bool verbose = argResults['verbose'];

    AtSignLogger.root_level = verbose ? 'info' : 'warning';

    final AtOnboardingPreference preference = AtNotificationsDemoUtil.generatePreference(notifier, namespace);

    final AtOnboardingService atOnboardingService = AtOnboardingServiceImpl(notifier, preference);
    final bool pkamAutheneticated = await atOnboardingService.authenticate();

    if(!pkamAutheneticated) {
        throw Exception('Unable to authenticate $subscriber');
    }

    stdout.writeln('Authenticated as $notifier');

    final AtClient atClient = atOnboardingService.atClient!;

    final NotificationService notificationService = atClient.notificationService;

    late NotificationParams params;

    final Metadata metadata = Metadata()
        ..ttl = 86400000 // 1 day
        ..ccd = true
        ..isEncrypted = true
        ..isPublic = false
        ..ttr = -1 // ttr must be -1 for a notification's value to be sent
    ;

    final AtKey atKey = AtKey()
        ..sharedBy = notifier
        ..sharedWith = subscriber
        ..namespace = namespace
        ..key = 'message'
        ..metadata = metadata
    ;

    params = NotificationParams.forUpdate(atKey, value: message);

    final NotificationResult notificationResult = await notificationService.notify(params);
    if(notificationResult.notificationStatusEnum == NotificationStatusEnum.delivered) {
        stdout.writeln('Successfully sent notification to $subscriber');
        _printNotificationParams(params);
        exit(0);
    } else {
        stdout.writeln('Failed to send notification to $subscriber');
        _printNotificationParams(params);
        exit(1);
    }
}

void _printNotificationParams(NotificationParams params) {
    final String id = params.id;
    final AtKey atKey = params.atKey;
    final String? value = params.value;
    final OperationEnum operation = params.operation;
    final MessageTypeEnum messageType = params.messageType;
    final PriorityEnum priority = params.priority;
    final StrategyEnum strategy = params.strategy;
    final int latestN = params.latestN;
    final String notifier = params.notifier;
    final Duration notificationExpiry = params.notificationExpiry;

    stdout.writeln('\tNotification ID: $id');
    stdout.writeln('\tAtKey: $atKey');
    stdout.writeln('\tValue: $value');
    stdout.writeln('\tOperation: $operation');
    stdout.writeln('\tMessage Type: $messageType');
    stdout.writeln('\tPriority: $priority');
    stdout.writeln('\tStrategy: $strategy');
    stdout.writeln('\tLatest N: $latestN');
    stdout.writeln('\tNotifier: $notifier');
    stdout.writeln('\tNotification Expiry: $notificationExpiry');
}