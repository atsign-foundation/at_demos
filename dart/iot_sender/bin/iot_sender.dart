import 'package:at_lookup/at_lookup.dart';
import 'package:iot_sender/at_onboarding_cli.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart' as common;

import 'package:iot_sender/iot_mqtt_listener.dart';
import 'dart:io';

void main(List<String> arguments) async {
  var toAtsigns = arguments;
  if (toAtsigns.isEmpty) {
    print('Usage: iot_sender <@sign>');
    exit(0);
  }
  String toAtsign = toAtsigns[0];

  OnboardingService onboardingService = OnboardingService('blackdeath');
  await onboardingService.authenticate();
  AtLookupImpl atLookup = onboardingService.getAtLookup();
  var keys = await atLookup.scan(auth: true);
  print('scan ${keys.toString()}');

  var pkam = await onboardingService.privateKey();
  var encryptSelfKey = await onboardingService.selfEncryptionKey();
  var encryptPrivateKey = await onboardingService.privateEncryptionKey();

  String atsign = '@blackdeath';
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

  iotListen(atClient, atsign, toAtsign);
  print('listening');
}
