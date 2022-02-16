import 'package:at_lookup/at_lookup.dart';
import 'package:iot_sender/at_onboarding_cli.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart' as common;

import 'package:iot_sender/iot_mqtt_listener.dart';
import 'dart:io';

void main(List<String> arguments) async {
  if (arguments.isEmpty || arguments.length != 2) {
    print('Usage: iot_sender <sender @sign> <reciever @sign>');
    exit(0);
  }

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


  print('Listening for mqtt');

  iotListen(atClient, atsign, toAtsign);
  print('listening');
}
