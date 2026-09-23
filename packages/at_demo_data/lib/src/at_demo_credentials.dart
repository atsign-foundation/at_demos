library at_demo_data.at_demo_credentials;

part 'constants/relay1_keys.dart';
part 'constants/relay2_keys.dart';
part 'constants/device1_keys.dart';
part 'constants/cloudvm1_keys.dart';
part 'constants/gateway1_keys.dart';
part 'constants/gateway2_keys.dart';
part 'constants/policy1_keys.dart';
part 'constants/policy2_keys.dart';
part 'constants/cloudvm2_keys.dart';
part 'constants/device2_keys.dart';
part 'constants/client1_keys.dart';
part 'constants/client2_keys.dart';
part 'constants/telemetry1_keys.dart';
part 'constants/telemetry2_keys.dart';
part 'constants/producer1_keys.dart';
part 'constants/producer2_keys.dart';
part 'constants/producer3_keys.dart';
part 'constants/producer4_keys.dart';
part 'constants/producer5_keys.dart';

/// Legacy VE Atsigns (plus the unauthenticated `anonymous` entry).
/// The VE installs each Atsign's CRAM secret, PKAM public key, and encryption
/// public key on its Atsign Server. Private keys stay with the client.
List<String> allAtsigns = <String>[
  'anonymous',
  '@relay1',
  '@relay2',
  '@device1',
  '@cloudvm1',
  '@gateway1',
  '@gateway2',
  '@policy1',
  '@policy2',
  '@client1',
  '@client2',
  '@telemetry1',
  '@telemetry2',
  '@producer1',
  '@producer2',
  '@producer3',
  '@producer4',
  '@producer5',
];

/// APKAM-path VE Atsigns. The VE configures their CRAM secrets but does not
/// preconfigure their public authentication keys on the Atsign Server. During
/// onboarding, the client generates an APKAM keypair and enrolls its public
/// key, as in production. The private key stays with the client.
List<String> apkamAtsigns = <String>[
  '@device2',
  '@cloudvm2',
];

/// A Map of cram (Challenge Response Authentication Mechanism) keys.
/// For more information on CRAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#cram)
Map<String, String> cramKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._cramKey,
  '@relay2': Relay2Keys._cramKey,
  '@device1': Device1Keys._cramKey,
  '@cloudvm1': Cloudvm1Keys._cramKey,
  '@gateway1': Gateway1Keys._cramKey,
  '@gateway2': Gateway2Keys._cramKey,
  '@policy1': Policy1Keys._cramKey,
  '@policy2': Policy2Keys._cramKey,
  '@device2': Device2Keys._cramKey,
  '@cloudvm2': Cloudvm2Keys._cramKey,
  '@client1': Client1Keys._cramKey,
  '@client2': Client2Keys._cramKey,
  '@telemetry1': Telemetry1Keys._cramKey,
  '@telemetry2': Telemetry2Keys._cramKey,
  '@producer1': Producer1Keys._cramKey,
  '@producer2': Producer2Keys._cramKey,
  '@producer3': Producer3Keys._cramKey,
  '@producer4': Producer4Keys._cramKey,
  '@producer5': Producer5Keys._cramKey,
};

/// Map of user's public pkam( Public Key Authentication Mechanism) keys.
/// For more information on PKAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#pkam)
Map<String, String> pkamPublicKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._pkamPublicKey,
  '@relay2': Relay2Keys._pkamPublicKey,
  '@device1': Device1Keys._pkamPublicKey,
  '@cloudvm1': Cloudvm1Keys._pkamPublicKey,
  '@gateway1': Gateway1Keys._pkamPublicKey,
  '@gateway2': Gateway2Keys._pkamPublicKey,
  '@policy1': Policy1Keys._pkamPublicKey,
  '@policy2': Policy2Keys._pkamPublicKey,
  '@device2': Device2Keys._pkamPublicKey,
  '@cloudvm2': Cloudvm2Keys._pkamPublicKey,
  '@client1': Client1Keys._pkamPublicKey,
  '@client2': Client2Keys._pkamPublicKey,
  '@telemetry1': Telemetry1Keys._pkamPublicKey,
  '@telemetry2': Telemetry2Keys._pkamPublicKey,
  '@producer1': Producer1Keys._pkamPublicKey,
  '@producer2': Producer2Keys._pkamPublicKey,
  '@producer3': Producer3Keys._pkamPublicKey,
  '@producer4': Producer4Keys._pkamPublicKey,
  '@producer5': Producer5Keys._pkamPublicKey,
};

/// Map of user's private pkam( Public Key Authentication Mechanism) keys.
/// For more information on PKAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#pkam)
Map<String, String> pkamPrivateKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._pkamPrivateKey,
  '@relay2': Relay2Keys._pkamPrivateKey,
  '@device1': Device1Keys._pkamPrivateKey,
  '@cloudvm1': Cloudvm1Keys._pkamPrivateKey,
  '@gateway1': Gateway1Keys._pkamPrivateKey,
  '@gateway2': Gateway2Keys._pkamPrivateKey,
  '@policy1': Policy1Keys._pkamPrivateKey,
  '@policy2': Policy2Keys._pkamPrivateKey,
  '@device2': Device2Keys._pkamPrivateKey,
  '@cloudvm2': Cloudvm2Keys._pkamPrivateKey,
  '@client1': Client1Keys._pkamPrivateKey,
  '@client2': Client2Keys._pkamPrivateKey,
  '@telemetry1': Telemetry1Keys._pkamPrivateKey,
  '@telemetry2': Telemetry2Keys._pkamPrivateKey,
  '@producer1': Producer1Keys._pkamPrivateKey,
  '@producer2': Producer2Keys._pkamPrivateKey,
  '@producer3': Producer3Keys._pkamPrivateKey,
  '@producer4': Producer4Keys._pkamPrivateKey,
  '@producer5': Producer5Keys._pkamPrivateKey,
};

/// Map of user's private encryption keys.
Map<String, String> encryptionPrivateKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._encryptionPrivateKey,
  '@relay2': Relay2Keys._encryptionPrivateKey,
  '@device1': Device1Keys._encryptionPrivateKey,
  '@cloudvm1': Cloudvm1Keys._encryptionPrivateKey,
  '@gateway1': Gateway1Keys._encryptionPrivateKey,
  '@gateway2': Gateway2Keys._encryptionPrivateKey,
  '@policy1': Policy1Keys._encryptionPrivateKey,
  '@policy2': Policy2Keys._encryptionPrivateKey,
  '@device2': Device2Keys._encryptionPrivateKey,
  '@cloudvm2': Cloudvm2Keys._encryptionPrivateKey,
  '@client1': Client1Keys._encryptionPrivateKey,
  '@client2': Client2Keys._encryptionPrivateKey,
  '@telemetry1': Telemetry1Keys._encryptionPrivateKey,
  '@telemetry2': Telemetry2Keys._encryptionPrivateKey,
  '@producer1': Producer1Keys._encryptionPrivateKey,
  '@producer2': Producer2Keys._encryptionPrivateKey,
  '@producer3': Producer3Keys._encryptionPrivateKey,
  '@producer4': Producer4Keys._encryptionPrivateKey,
  '@producer5': Producer5Keys._encryptionPrivateKey,
};

/// Map of user's public encryption keys.
Map<String, String> encryptionPublicKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._encryptionPublicKey,
  '@relay2': Relay2Keys._encryptionPublicKey,
  '@device1': Device1Keys._encryptionPublicKey,
  '@cloudvm1': Cloudvm1Keys._encryptionPublicKey,
  '@gateway1': Gateway1Keys._encryptionPublicKey,
  '@gateway2': Gateway2Keys._encryptionPublicKey,
  '@policy1': Policy1Keys._encryptionPublicKey,
  '@policy2': Policy2Keys._encryptionPublicKey,
  '@device2': Device2Keys._encryptionPublicKey,
  '@cloudvm2': Cloudvm2Keys._encryptionPublicKey,
  '@client1': Client1Keys._encryptionPublicKey,
  '@client2': Client2Keys._encryptionPublicKey,
  '@telemetry1': Telemetry1Keys._encryptionPublicKey,
  '@telemetry2': Telemetry2Keys._encryptionPublicKey,
  '@producer1': Producer1Keys._encryptionPublicKey,
  '@producer2': Producer2Keys._encryptionPublicKey,
  '@producer3': Producer3Keys._encryptionPublicKey,
  '@producer4': Producer4Keys._encryptionPublicKey,
  '@producer5': Producer5Keys._encryptionPublicKey,
};

/// Map of user's AES keys.
Map<String, String> aesKeyMap = <String, String>{
  '@relay1': Relay1Keys._aesKey,
  '@relay2': Relay2Keys._aesKey,
  '@device1': Device1Keys._aesKey,
  '@cloudvm1': Cloudvm1Keys._aesKey,
  '@gateway1': Gateway1Keys._aesKey,
  '@gateway2': Gateway2Keys._aesKey,
  '@policy1': Policy1Keys._aesKey,
  '@policy2': Policy2Keys._aesKey,
  '@device2': Device2Keys._aesKey,
  '@cloudvm2': Cloudvm2Keys._aesKey,
  '@client1': Client1Keys._aesKey,
  '@client2': Client2Keys._aesKey,
  '@telemetry1': Telemetry1Keys._aesKey,
  '@telemetry2': Telemetry2Keys._aesKey,
  '@producer1': Producer1Keys._aesKey,
  '@producer2': Producer2Keys._aesKey,
  '@producer3': Producer3Keys._aesKey,
  '@producer4': Producer4Keys._aesKey,
  '@producer5': Producer5Keys._aesKey,
};

// APKAM symmetric keys
Map<String, String> apkamSymmetricKeyMap = <String, String>{
  '@relay1': Relay1Keys._apkamSymmetricKey,
  '@relay2': Relay2Keys._apkamSymmetricKey,
  '@device1': Device1Keys._apkamSymmetricKey,
  '@cloudvm1': Cloudvm1Keys._apkamSymmetricKey,
  '@gateway1': Gateway1Keys._apkamSymmetricKey,
  '@gateway2': Gateway2Keys._apkamSymmetricKey,
  '@policy1': Policy1Keys._apkamSymmetricKey,
  '@policy2': Policy2Keys._apkamSymmetricKey,
  '@device2': Device2Keys._apkamSymmetricKey,
  '@cloudvm2': Cloudvm2Keys._apkamSymmetricKey,
  '@client1': Client1Keys._apkamSymmetricKey,
  '@client2': Client2Keys._apkamSymmetricKey,
  '@telemetry1': Telemetry1Keys._apkamSymmetricKey,
  '@telemetry2': Telemetry2Keys._apkamSymmetricKey,
  '@producer1': Producer1Keys._apkamSymmetricKey,
  '@producer2': Producer2Keys._apkamSymmetricKey,
  '@producer3': Producer3Keys._apkamSymmetricKey,
  '@producer4': Producer4Keys._apkamSymmetricKey,
  '@producer5': Producer5Keys._apkamSymmetricKey,
};

// APKAM Private Keys
Map<String, String> apkamPrivateKeyMap = <String, String>{
  '@relay1': Relay1Keys._apkamPrivateKey,
  '@client1': Client1Keys._apkamPrivateKey,
  '@client2': Client2Keys._apkamPrivateKey,
  '@telemetry1': Telemetry1Keys._apkamPrivateKey,
  '@telemetry2': Telemetry2Keys._apkamPrivateKey,
  '@producer1': Producer1Keys._apkamPrivateKey,
  '@producer2': Producer2Keys._apkamPrivateKey,
  '@producer3': Producer3Keys._apkamPrivateKey,
  '@producer4': Producer4Keys._apkamPrivateKey,
  '@producer5': Producer5Keys._apkamPrivateKey,
};

// APKAM Public Keys
Map<String, String> apkamPublicKeyMap = <String, String>{
  '@relay1': Relay1Keys._apkamPublicKey,
  '@client1': Client1Keys._apkamPublicKey,
  '@client2': Client2Keys._apkamPublicKey,
  '@telemetry1': Telemetry1Keys._apkamPublicKey,
  '@telemetry2': Telemetry2Keys._apkamPublicKey,
  '@producer1': Producer1Keys._apkamPublicKey,
  '@producer2': Producer2Keys._apkamPublicKey,
  '@producer3': Producer3Keys._apkamPublicKey,
  '@producer4': Producer4Keys._apkamPublicKey,
  '@producer5': Producer5Keys._apkamPublicKey,
};
