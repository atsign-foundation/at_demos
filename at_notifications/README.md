# at_notifications

This is a demo of using `.notify` and `.subscribe` to send/receive notifications in the atPlatform.

Demo uses [at_client] as the core dependency to utilize the atProtocol and [at_onboarding_cli] to authenticate atSigns to their atServers.

## Getting Started

A summary of `bin/` files:

- `subscribe-to-notifier.dart` @subscriber is listens for notifications received from @notifier
- `notifiy-the-subscriber.dart` @notifier sends a notification to @subscriber

1. To run this demo, you will need 2 atSigns and thier .atKeys in `~/.atsign/keys` directory.

2. Simply start your subscriber with the following command:

```sh
dart run subscribe.dart -a @subscriber -r ".*@notifier"
```

Example output:

```
Authenticated as @subscriber
Subscribed to notifications with regex ".*"
```

3. Run the notify program to send a notification to the subscriber:

```sh
dart run notify-the-subscriber.dart -f @notifier -t @subscriber -m "hello, world"
```

4. You should see a similar output in the subscriber's terminal:

```sh
[NOTIFICATION RECEIVED] =>
    id: 2704e281-c882-4ab2-8cb9-6c54fba538f5
    key: @soccer99:message.at_notifications_demo@soccer0
    from: @soccer0
    to: @soccer99
    epochMillis: 1686525575956
    status: 
    value: poopy
    operation: update
    messageType: MessageType.key
    isEncrypted: true
    expiresAtInEpochMillis: null
    metadata: Metadata{ttl: null, ttb: null, ttr: null,ccd: null, isPublic: false, isHidden: false, availableAt : null, expiresAt : null, refreshAt : null, createdAt : null, updatedAt : null, isBinary : false, isEncrypted : null, isCached : false, dataSignature: null, sharedKeyStatus: null, encryptedSharedKey: null, pubKeyCheckSum: null, encoding: null, encKeyName: null, encAlgo: null, ivNonce: 65NeBNKzEqksyeTS1Wbm+g==, skeEncKeyName: null, skeEncAlgo: null}
```

## subscribe.dart

Usage

```sh
dart run subscribe.dart
-a, --a (mandatory)    atSign listening for notifications
-r, --regex            the regex to filter notifications with
                       (defaults to ".*")
-n, --namespace        namespace of the app
                       (defaults to "at_notifications_demo")
-v, --[no-]verbose     more logging
-d, --[no-]decrypt     should decrypt notifications
                       (defaults to on)
```

## send-notification.dart

Usage

```sh
dart run send-notification.dart
-f, --from (mandatory)    the atSign sending the notification (must be authenticated with keys)
-t, --to (mandatory)      the atSign listening for notifications
-m, --message             the message to send
                          (defaults to "Hello, World!")
-n, --namespace           namespace of the app
                          (defaults to "at_notifications_demo")
-v, --[no-]verbose        more logging
```