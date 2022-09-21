import 'dart:io';

// external packages
import 'package:args/args.dart';
import 'package:logging/src/level.dart';

// atPlatform packages
import 'package:at_client/at_client.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_onboarding_cli/at_onboarding_cli.dart';

// Local Packages
import 'package:iot_sender/home_directory.dart';
import 'package:iot_sender/check_file_exists.dart';

void main(List<String> args) async {
  var parser = ArgParser();
// Args
  parser.addOption('key-file',
      abbr: 'k',
      mandatory: false,
      help: 'This device\'s atSign\'s atKeys file if not in ~/.atsign/keys/');
  parser.addOption('atsign',
      abbr: 'a', mandatory: true, help: 'Device Manager\'s atSign');
  parser.addOption('device',
      abbr: 'd', mandatory: true, help: 'atSign of the  device');
  parser.addOption('device-name',
      abbr: 'n', mandatory: true, help: 'Device name');
  parser.addFlag('verbose', abbr: 'v', help: 'More logging');

  // Check the arguments
  String nameSpace = 'fourballcorporate9';
  String rootDomain = 'root.atsign.org';
  AtSignLogger.root_level = 'SEVERE';

  dynamic results;
  String atsignFile;
  String fromAtsign = 'unknown';
  String deviceName = 'unknown';
  String deviceAtsign = 'unknown';
  String? homeDirectory = getHomeDirectory();

  final AtSignLogger logger = AtSignLogger('iot_sender');
  try {
    // Arg check
    results = parser.parse(args);
    fromAtsign = results['atsign'];
    deviceName = results['device-name'];
    deviceAtsign = results['device'];
    if (results['key-file'] != null) {
      atsignFile = results['key-file'];
    } else {
      atsignFile = '${fromAtsign}_key.atKeys';
      atsignFile = '$homeDirectory/.atsign/keys/$atsignFile';
    }
    // Check atKeyFile selected exists
    if (!await fileExists(atsignFile)) {
      throw ('\n Unable to find .atKeys file : $atsignFile');
    }
  } catch (e) {
    print(parser.usage);
    print(e);
    exit(1);
  }

// Now on to the @platform startup
  if (results['verbose']) {
    logger.logger.level = Level.INFO;

    AtSignLogger.root_level = 'INFO';
  }

  //onboarding preference builder can be used to set onboardingService parameters
  AtOnboardingPreference atOnboardingConfig = AtOnboardingPreference()
    ..hiveStoragePath =
        '$homeDirectory/.$nameSpace/$fromAtsign/$deviceName/storage'
    ..namespace = nameSpace
    ..downloadPath = '$homeDirectory/.$nameSpace/files'
    ..isLocalStoreRequired = true
    ..commitLogPath =
        '$homeDirectory/.$nameSpace/$fromAtsign/$deviceName/storage/commitLog'
    ..rootDomain = rootDomain
    ..atKeysFilePath = atsignFile;
  AtOnboardingService onboardingService =
      AtOnboardingServiceImpl(fromAtsign, atOnboardingConfig);
  await onboardingService.authenticate();
  AtClient? atClient = await onboardingService.getAtClient();
  AtClientManager atClientManager = AtClientManager.getInstance();

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
    await Future.delayed(Duration(milliseconds: 500));
    stderr.write(".");
  }
  logger.info("Initial sync complete");
  logger.info('OK Ready');

  String receiversString =
      '[{"sendToAtsign":"@atgps_receiver","sendHR": true,"sendO2": true,"sendToShortname":"bob"},{"sendToAtsign":"@atgps02","sendHR": true,"sendO2": false,"sendToShortname":"world"}]';
  logger.info("calling iotListen atSign '$fromAtsign'");
  // iotListen(atClientManager,notificationService, ownerAtsign, fromAtsign);

  String? currentAtsign;
  currentAtsign = atClient?.getCurrentAtSign();

  var metaData = Metadata()
    ..isPublic = false
    ..isEncrypted = true

    ///..ttr = 10
    ..namespaceAware = true;

  var key = AtKey()
    ..key = '$deviceName.config'
    ..sharedWith = currentAtsign
    ..namespace = atClient?.getPreferences()!.namespace
    ..sharedBy = fromAtsign
    ..sharedWith = deviceAtsign
    ..metadata = metaData;

  try {
    await atClient?.put(key, receiversString);
    //exit(0);
  } catch (e) {
    print(e.toString());
  }

  logger.info("Waiting for final sync");
  syncComplete = false;
  atClientManager.syncService.sync(onDone: onSyncDone);
  while (!syncComplete) {
    await Future.delayed(Duration(milliseconds: 500));
    stderr.write(".");
  }
  logger.info("Final sync complete");
  logger.info('OK Ready');
  exit(0);
}
