import 'package:at_utils/at_logger.dart';
import 'package:iot_sender/at_onboarding_cli.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart' as common;

import 'package:iot_sender/iot_mqtt_listener.dart';
import 'dart:io';

void main(List<String> arguments) async {
  void printUsage() {
    print('Usage: iot_sender <sender @sign> <receiver @sign> [<mode>]');
    exit(0);
  }

  if (arguments.isEmpty || arguments.length < 2 || arguments.length > 3) {
    printUsage();
  }

  AtSignLogger.root_level = 'INFO';

  final AtSignLogger logger = AtSignLogger('iot_sender');

  String atsign = arguments[0];
  String toAtsign = arguments[1];

  bool sendHR = true;
  bool sendO2 = true;

  if (arguments.length > 2) {
    String mode = arguments[2].toLowerCase();
    switch(mode) {
      case 'hr':
        sendHR = true;
        break;
      case 'o2':
        sendO2 = true;
        break;
      case 'hro2':
        sendHR = true;
        sendO2 = true;
        break;
      default:
        printUsage();
    }
  }

  OnboardingService onboardingService = OnboardingService(atsign);
  await onboardingService.authenticate();

  var pkam = await onboardingService.privateKey();
  var encryptSelfKey = await onboardingService.selfEncryptionKey();
  var encryptPrivateKey = await onboardingService.privateEncryptionKey();
  var encryptPublicKey = await onboardingService.publicEncryptionKey();

  String namespace = 'fourballcorporate9';
  AtClientManager atClientManager = AtClientManager.getInstance();
  AtClient atClient;

  var preference = AtClientPreference()
    ..hiveStoragePath = 'lib/hive/client'
    ..commitLogPath = 'lib/hive/client/commit'
    ..isLocalStoreRequired = true
    ..privateKey = pkam
    ..rootDomain = 'root.atsign.org';

  atClientManager = AtClientManager.getInstance();
  await atClientManager.setCurrentAtSign(atsign, namespace, preference);
  atClient = atClientManager.atClient;

  await atClient
      .getLocalSecondary()
      ?.putValue(common.AT_ENCRYPTION_PRIVATE_KEY, encryptPrivateKey!);

  await atClient
      .getLocalSecondary()
      ?.putValue(common.AT_ENCRYPTION_SELF_KEY, encryptSelfKey!);

  await atClient
      .getLocalSecondary()
      ?.putValue(common.AT_ENCRYPTION_PUBLIC_KEY+atsign, encryptPublicKey!);

  bool syncComplete = false;
  void onSyncDone(syncResult) {
    logger.info("syncResult.syncStatus: ${syncResult.syncStatus}");
    logger.info("syncResult.lastSyncedOn ${syncResult.lastSyncedOn}");
    syncComplete = true;
  }

  // Wait for initial sync to complete
  logger.info("Waiting for initial sync");
  syncComplete = false;
  atClientManager.syncService.sync(onDone: onSyncDone);
  while (!syncComplete) {
    await Future.delayed(Duration(milliseconds: 100));
  }
  logger.info("Initial sync complete");
  logger.info('OK Ready');

  logger.info("calling iotListen atSign '$atsign', toAtSign '$toAtsign'");
  iotListen(atClient, atsign, toAtsign, sendHR:sendHR, sendO2:sendO2);
  print('listening');
}
