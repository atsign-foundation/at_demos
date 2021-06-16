//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<at_backupkey_flutter/AtBackupkeyFlutterPlugin.h>)
#import <at_backupkey_flutter/AtBackupkeyFlutterPlugin.h>
#else
@import at_backupkey_flutter;
#endif

#if __has_include(<at_chat_flutter/AtChatFlutterPlugin.h>)
#import <at_chat_flutter/AtChatFlutterPlugin.h>
#else
@import at_chat_flutter;
#endif

#if __has_include(<at_onboarding_flutter/AtOnboardingFlutterPlugin.h>)
#import <at_onboarding_flutter/AtOnboardingFlutterPlugin.h>
#else
@import at_onboarding_flutter;
#endif

#if __has_include(<file_picker/FilePickerPlugin.h>)
#import <file_picker/FilePickerPlugin.h>
#else
@import file_picker;
#endif

#if __has_include(<flutter_keychain/FlutterKeychainPlugin.h>)
#import <flutter_keychain/FlutterKeychainPlugin.h>
#else
@import flutter_keychain;
#endif

#if __has_include(<flutter_qr_reader/FlutterQrReaderPlugin.h>)
#import <flutter_qr_reader/FlutterQrReaderPlugin.h>
#else
@import flutter_qr_reader;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<permission_handler/PermissionHandlerPlugin.h>)
#import <permission_handler/PermissionHandlerPlugin.h>
#else
@import permission_handler;
#endif

#if __has_include(<share/FLTSharePlugin.h>)
#import <share/FLTSharePlugin.h>
#else
@import share;
#endif

#if __has_include(<url_launcher/FLTURLLauncherPlugin.h>)
#import <url_launcher/FLTURLLauncherPlugin.h>
#else
@import url_launcher;
#endif

#if __has_include(<webview_flutter/FLTWebViewFlutterPlugin.h>)
#import <webview_flutter/FLTWebViewFlutterPlugin.h>
#else
@import webview_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AtBackupkeyFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"AtBackupkeyFlutterPlugin"]];
  [AtChatFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"AtChatFlutterPlugin"]];
  [AtOnboardingFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"AtOnboardingFlutterPlugin"]];
  [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
  [FlutterKeychainPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterKeychainPlugin"]];
  [FlutterQrReaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterQrReaderPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [FLTURLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTURLLauncherPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
