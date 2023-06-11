import 'dart:io';

import 'package:at_onboarding_cli/at_onboarding_cli.dart';
import 'package:at_utils/at_utils.dart';
import 'package:version/version.dart';

class AtNotificationsDemoUtil {
	// Get the home directory or null if unknown.
	static String? getHomeDirectory() {
		switch (Platform.operatingSystem) {
		case 'linux':
		case 'macos':
		  return Platform.environment['HOME'];
		case 'windows':
		  return Platform.environment['USERPROFILE'];
		case 'android':
		  // Probably want internal storage.
		  return '/storage/sdcard0';
		case 'ios':
		  // iOS doesn't really have a home directory.
		  return null;
		case 'fuchsia':
		  // I have no idea.
		  return null;
		default:
		  return null;
    	}
	}

    static String? getAtKeysFilePath(final String atSign) {
		final String formattedAtSign = AtUtils.fixAtSign(atSign);
		return '${getHomeDirectory()}/.atsign/keys/${formattedAtSign}_key.atKeys';
	}

    static AtOnboardingPreference generatePreference(final String atSign, final String? namespace) {
        AtOnboardingPreference pref = AtOnboardingPreference()
            ..atKeysFilePath = getAtKeysFilePath(atSign)
            ..namespace = namespace
            ..useAtChops = true
            ..atProtocolEmitted = Version(2, 0, 0)
            ..isLocalStoreRequired = true
            ..commitLogPath = '${getHomeDirectory()}/.atsign/temp/$atSign/commitlog'
            ..downloadPath = '${getHomeDirectory()}/.atsign/temp/$atSign/download'
            ..hiveStoragePath = '${getHomeDirectory()}/.atsign/temp/$atSign/hive'
            ;
        return pref;
    }
}
