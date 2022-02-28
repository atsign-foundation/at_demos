import 'package:at_utils/at_logger.dart';
import 'package:iot_sender/at_onboarding_cli.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart' as common;

import 'package:iot_sender/iot_mqtt_listener.dart';
import 'package:max30101/max30101.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:io';

import 'package:mqtt_client/mqtt_server_client.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty || arguments.length < 2) {
    print('Usage: iot_sender <sender @sign> <receiver @sign>');
    exit(0);
  }

  AtSignLogger.root_level = 'INFO';

  final AtSignLogger logger = AtSignLogger('iot_sender');

  String atsign = arguments[0];
  String toAtsign = arguments[1];

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


  ///
  /// The iot_mqtt_listener will subscribe to mqtt topics and puts the values to the atSign
  /// The listener subscribes to multiple topics to support various iterations of this demo
  /// Previous sender was subscribing to outputs from the python sensor driver and publishing
  /// on the mwc_hr and mwc_o2 topics
  ///
  /// This sender integrates with the sensor and publishes on 'mwc_beat_hr_o2' topic
  /// Which in turn is subscribed to by (a) the python TFT driver (b) the iot_mqtt_listener
  ///
  logger.info("calling iotListen atSign '$atsign', toAtSign '$toAtsign'");
  iotListen(atClient, atsign, toAtsign);
  print('listening');


  ///
  /// The MAX30101 sensor driver
  ///
  logger.info("Starting Max30101 sampler");

  final mqttClient = MqttServerClient('localhost', '');

  void onBeat(bool beatDetected, double bpm, double sao2) {
    logger.info("onBeat called with beatDetected:$beatDetected bpm:$bpm sao2:$sao2");
    String message = '${beatDetected.toString().toLowerCase()},${bpm.toStringAsFixed(1)},${sao2.toStringAsFixed(1)}';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    mqttClient.publishMessage('mwc_beat_hr_o2', MqttQos.atLeastOnce, builder.payload!);
  }

  MAX30101 max30101 = MAX30101(RealI2CWrapper(1), false, debug:false);
  max30101.runSampler(onBeat);
}
