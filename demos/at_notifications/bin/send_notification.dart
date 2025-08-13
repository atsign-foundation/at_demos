

import 'dart:io';

import 'package:args/args.dart';
import 'package:at_client/at_client.dart';
import 'package:at_notifications/constants.dart';
import 'package:at_notifications/util.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:at_utils/at_utils.dart';

// dart run send_notification.dart -f @notifier -t @subscriber -m "lemonade"
void main(List<String> arguments) async {
    final ArgParser argParser = ArgParser();
    argParser.addOption('from', abbr: 'f', help: 'the atSign sending the notification (must be authenticated with keys)', mandatory: true);
    argParser.addOption('to', abbr: 't', help: 'the atSign listening for notifications', mandatory: true);
    argParser.addOption('message', abbr: 'm', help: 'the message to send', mandatory: false, defaultsTo: 'Hello, World!');
    argParser.addOption('namespace', abbr: 'n', help: 'namespace of the app', mandatory: false, defaultsTo: AtNotificationsDemoConstants.defaultNamespace);
    argParser.addFlag('verbose', abbr: 'v', help: 'more logging', negatable: true, defaultsTo: AtNotificationsDemoConstants.defaultVerbose);

    final ArgResults argResults = argParser.parse(arguments);

    late String notifier;
    late String subscriber;
    late String message;
    late String namespace;
    late bool verbose;
    
    try {
        notifier = AtUtils.fixAtSign(argResults['from']);
        subscriber = AtUtils.fixAtSign(argResults['to']);
        message = argResults['message'];
        namespace = argResults['namespace'];
        verbose = argResults['verbose'];
    } catch (e) {
        stdout.writeln(argParser.usage);
        exit(0);
    }

    AtSignLogger.root_level = verbose ? 'info' : 'warning';

    final AtOnboardingPreference preference = AtNotificationsDemoUtil.generatePreference(notifier, namespace);

    final AtOnboardingService atOnboardingService = AtOnboardingServiceImpl(notifier, preference);
    final bool pkamAutheneticated = await atOnboardingService.authenticate();

    if(!pkamAutheneticated) {
        throw Exception('Unable to authenticate $notifier');
    }

    stdout.writeln('Authenticated as $notifier');

    final AtClient atClient = atOnboardingService.atClient!;

    final NotificationService notificationService = atClient.notificationService;

    late NotificationParams params;

    final Metadata metadata = Metadata()
        ..isEncrypted = true
        ..isPublic = false
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