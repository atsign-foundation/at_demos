//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<at_chat_flutter/AtChatFlutterPlugin.h>)
#import <at_chat_flutter/AtChatFlutterPlugin.h>
#else
@import at_chat_flutter;
#endif

#if __has_include(<flutter_keychain/FlutterKeychainPlugin.h>)
#import <flutter_keychain/FlutterKeychainPlugin.h>
#else
@import flutter_keychain;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AtChatFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"AtChatFlutterPlugin"]];
  [FlutterKeychainPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterKeychainPlugin"]];
}

@end
