library at_demo_data.at_demo_credentials;

part 'constants/relay1_keys.dart';
part 'constants/relay2_keys.dart';
part 'constants/relay3_keys.dart';
part 'constants/relay4_keys.dart';
part 'constants/relay5_keys.dart';
part 'constants/relay6_keys.dart';
part 'constants/device1_keys.dart';
part 'constants/cloudvm1_keys.dart';
part 'constants/gateway1_keys.dart';
part 'constants/gateway2_keys.dart';
part 'constants/policy1_keys.dart';
part 'constants/policy2_keys.dart';
part 'constants/events1_keys.dart';
part 'constants/events2_keys.dart';
part 'constants/cloudvm2_keys.dart';
part 'constants/device2_keys.dart';
part 'constants/device3_keys.dart';
part 'constants/device4_keys.dart';
part 'constants/device5_keys.dart';
part 'constants/device6_keys.dart';
part 'constants/client1_keys.dart';
part 'constants/client2_keys.dart';
part 'constants/client3_keys.dart';
part 'constants/client4_keys.dart';
part 'constants/client5_keys.dart';
part 'constants/client6_keys.dart';
part 'constants/telemetry1_keys.dart';
part 'constants/telemetry2_keys.dart';
part 'constants/producer1_keys.dart';
part 'constants/producer2_keys.dart';
part 'constants/producer3_keys.dart';
part 'constants/producer4_keys.dart';
part 'constants/producer5_keys.dart';
part 'constants/producer6_keys.dart';

/// Legacy VE Atsigns (plus the unauthenticated `anonymous` entry).
/// The VE installs each Atsign's CRAM secret, PKAM public key, and encryption
/// public key on its Atsign Server. Private keys stay with the client.
List<String> allAtsigns = <String>[
  'anonymous',
  '@relay1',
  '@relay2',
  '@relay3',
  '@relay4',
  '@relay5',
  '@relay6',
  '@device1',
  '@device3',
  '@device4',
  '@device5',
  '@device6',
  '@cloudvm1',
  '@gateway1',
  '@gateway2',
  '@policy1',
  '@policy2',
  '@events1',
  '@events2',
  '@client1',
  '@client2',
  '@client3',
  '@client4',
  '@client5',
  '@client6',
  '@telemetry1',
  '@telemetry2',
  '@producer1',
  '@producer2',
  '@producer3',
  '@producer4',
  '@producer5',
  '@producer6',
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
  '@relay3': Relay3Keys._cramKey,
  '@relay4': Relay4Keys._cramKey,
  '@relay5': Relay5Keys._cramKey,
  '@relay6': Relay6Keys._cramKey,
  '@device1': Device1Keys._cramKey,
  '@cloudvm1': Cloudvm1Keys._cramKey,
  '@gateway1': Gateway1Keys._cramKey,
  '@gateway2': Gateway2Keys._cramKey,
  '@policy1': Policy1Keys._cramKey,
  '@policy2': Policy2Keys._cramKey,
  '@events1': Events1Keys._cramKey,
  '@events2': Events2Keys._cramKey,
  '@device2': Device2Keys._cramKey,
  '@device3': Device3Keys._cramKey,
  '@device4': Device4Keys._cramKey,
  '@device5': Device5Keys._cramKey,
  '@device6': Device6Keys._cramKey,
  '@cloudvm2': Cloudvm2Keys._cramKey,
  '@client1': Client1Keys._cramKey,
  '@client2': Client2Keys._cramKey,
  '@client3': Client3Keys._cramKey,
  '@client4': Client4Keys._cramKey,
  '@client5': Client5Keys._cramKey,
  '@client6': Client6Keys._cramKey,
  '@telemetry1': Telemetry1Keys._cramKey,
  '@telemetry2': Telemetry2Keys._cramKey,
  '@producer1': Producer1Keys._cramKey,
  '@producer2': Producer2Keys._cramKey,
  '@producer3': Producer3Keys._cramKey,
  '@producer4': Producer4Keys._cramKey,
  '@producer5': Producer5Keys._cramKey,
  '@producer6': Producer6Keys._cramKey,
};

/// Map of user's public pkam( Public Key Authentication Mechanism) keys.
/// For more information on PKAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#pkam)
Map<String, String> pkamPublicKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._pkamPublicKey,
  '@relay2': Relay2Keys._pkamPublicKey,
  '@relay3': Relay3Keys._pkamPublicKey,
  '@relay4': Relay4Keys._pkamPublicKey,
  '@relay5': Relay5Keys._pkamPublicKey,
  '@relay6': Relay6Keys._pkamPublicKey,
  '@device1': Device1Keys._pkamPublicKey,
  '@cloudvm1': Cloudvm1Keys._pkamPublicKey,
  '@gateway1': Gateway1Keys._pkamPublicKey,
  '@gateway2': Gateway2Keys._pkamPublicKey,
  '@policy1': Policy1Keys._pkamPublicKey,
  '@policy2': Policy2Keys._pkamPublicKey,
  '@events1': Events1Keys._pkamPublicKey,
  '@events2': Events2Keys._pkamPublicKey,
  '@device2': Device2Keys._pkamPublicKey,
  '@device3': Device3Keys._pkamPublicKey,
  '@device4': Device4Keys._pkamPublicKey,
  '@device5': Device5Keys._pkamPublicKey,
  '@device6': Device6Keys._pkamPublicKey,
  '@cloudvm2': Cloudvm2Keys._pkamPublicKey,
  '@client1': Client1Keys._pkamPublicKey,
  '@client2': Client2Keys._pkamPublicKey,
  '@client3': Client3Keys._pkamPublicKey,
  '@client4': Client4Keys._pkamPublicKey,
  '@client5': Client5Keys._pkamPublicKey,
  '@client6': Client6Keys._pkamPublicKey,
  '@telemetry1': Telemetry1Keys._pkamPublicKey,
  '@telemetry2': Telemetry2Keys._pkamPublicKey,
  '@producer1': Producer1Keys._pkamPublicKey,
  '@producer2': Producer2Keys._pkamPublicKey,
  '@producer3': Producer3Keys._pkamPublicKey,
  '@producer4': Producer4Keys._pkamPublicKey,
  '@producer5': Producer5Keys._pkamPublicKey,
  '@producer6': Producer6Keys._pkamPublicKey,
};

/// Map of user's private pkam( Public Key Authentication Mechanism) keys.
/// For more information on PKAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#pkam)
Map<String, String> pkamPrivateKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._pkamPrivateKey,
  '@relay2': Relay2Keys._pkamPrivateKey,
  '@relay3': Relay3Keys._pkamPrivateKey,
  '@relay4': Relay4Keys._pkamPrivateKey,
  '@relay5': Relay5Keys._pkamPrivateKey,
  '@relay6': Relay6Keys._pkamPrivateKey,
  '@device1': Device1Keys._pkamPrivateKey,
  '@cloudvm1': Cloudvm1Keys._pkamPrivateKey,
  '@gateway1': Gateway1Keys._pkamPrivateKey,
  '@gateway2': Gateway2Keys._pkamPrivateKey,
  '@policy1': Policy1Keys._pkamPrivateKey,
  '@policy2': Policy2Keys._pkamPrivateKey,
  '@events1': Events1Keys._pkamPrivateKey,
  '@events2': Events2Keys._pkamPrivateKey,
  '@device2': Device2Keys._pkamPrivateKey,
  '@device3': Device3Keys._pkamPrivateKey,
  '@device4': Device4Keys._pkamPrivateKey,
  '@device5': Device5Keys._pkamPrivateKey,
  '@device6': Device6Keys._pkamPrivateKey,
  '@cloudvm2': Cloudvm2Keys._pkamPrivateKey,
  '@client1': Client1Keys._pkamPrivateKey,
  '@client2': Client2Keys._pkamPrivateKey,
  '@client3': Client3Keys._pkamPrivateKey,
  '@client4': Client4Keys._pkamPrivateKey,
  '@client5': Client5Keys._pkamPrivateKey,
  '@client6': Client6Keys._pkamPrivateKey,
  '@telemetry1': Telemetry1Keys._pkamPrivateKey,
  '@telemetry2': Telemetry2Keys._pkamPrivateKey,
  '@producer1': Producer1Keys._pkamPrivateKey,
  '@producer2': Producer2Keys._pkamPrivateKey,
  '@producer3': Producer3Keys._pkamPrivateKey,
  '@producer4': Producer4Keys._pkamPrivateKey,
  '@producer5': Producer5Keys._pkamPrivateKey,
  '@producer6': Producer6Keys._pkamPrivateKey,
};

/// Map of user's private encryption keys.
Map<String, String> encryptionPrivateKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._encryptionPrivateKey,
  '@relay2': Relay2Keys._encryptionPrivateKey,
  '@relay3': Relay3Keys._encryptionPrivateKey,
  '@relay4': Relay4Keys._encryptionPrivateKey,
  '@relay5': Relay5Keys._encryptionPrivateKey,
  '@relay6': Relay6Keys._encryptionPrivateKey,
  '@device1': Device1Keys._encryptionPrivateKey,
  '@cloudvm1': Cloudvm1Keys._encryptionPrivateKey,
  '@gateway1': Gateway1Keys._encryptionPrivateKey,
  '@gateway2': Gateway2Keys._encryptionPrivateKey,
  '@policy1': Policy1Keys._encryptionPrivateKey,
  '@policy2': Policy2Keys._encryptionPrivateKey,
  '@events1': Events1Keys._encryptionPrivateKey,
  '@events2': Events2Keys._encryptionPrivateKey,
  '@device2': Device2Keys._encryptionPrivateKey,
  '@device3': Device3Keys._encryptionPrivateKey,
  '@device4': Device4Keys._encryptionPrivateKey,
  '@device5': Device5Keys._encryptionPrivateKey,
  '@device6': Device6Keys._encryptionPrivateKey,
  '@cloudvm2': Cloudvm2Keys._encryptionPrivateKey,
  '@client1': Client1Keys._encryptionPrivateKey,
  '@client2': Client2Keys._encryptionPrivateKey,
  '@client3': Client3Keys._encryptionPrivateKey,
  '@client4': Client4Keys._encryptionPrivateKey,
  '@client5': Client5Keys._encryptionPrivateKey,
  '@client6': Client6Keys._encryptionPrivateKey,
  '@telemetry1': Telemetry1Keys._encryptionPrivateKey,
  '@telemetry2': Telemetry2Keys._encryptionPrivateKey,
  '@producer1': Producer1Keys._encryptionPrivateKey,
  '@producer2': Producer2Keys._encryptionPrivateKey,
  '@producer3': Producer3Keys._encryptionPrivateKey,
  '@producer4': Producer4Keys._encryptionPrivateKey,
  '@producer5': Producer5Keys._encryptionPrivateKey,
  '@producer6': Producer6Keys._encryptionPrivateKey,
};

/// Map of user's public encryption keys.
Map<String, String> encryptionPublicKeyMap = <String, String>{
  'anonymous': '',
  '@relay1': Relay1Keys._encryptionPublicKey,
  '@relay2': Relay2Keys._encryptionPublicKey,
  '@relay3': Relay3Keys._encryptionPublicKey,
  '@relay4': Relay4Keys._encryptionPublicKey,
  '@relay5': Relay5Keys._encryptionPublicKey,
  '@relay6': Relay6Keys._encryptionPublicKey,
  '@device1': Device1Keys._encryptionPublicKey,
  '@cloudvm1': Cloudvm1Keys._encryptionPublicKey,
  '@gateway1': Gateway1Keys._encryptionPublicKey,
  '@gateway2': Gateway2Keys._encryptionPublicKey,
  '@policy1': Policy1Keys._encryptionPublicKey,
  '@policy2': Policy2Keys._encryptionPublicKey,
  '@events1': Events1Keys._encryptionPublicKey,
  '@events2': Events2Keys._encryptionPublicKey,
  '@device2': Device2Keys._encryptionPublicKey,
  '@device3': Device3Keys._encryptionPublicKey,
  '@device4': Device4Keys._encryptionPublicKey,
  '@device5': Device5Keys._encryptionPublicKey,
  '@device6': Device6Keys._encryptionPublicKey,
  '@cloudvm2': Cloudvm2Keys._encryptionPublicKey,
  '@client1': Client1Keys._encryptionPublicKey,
  '@client2': Client2Keys._encryptionPublicKey,
  '@client3': Client3Keys._encryptionPublicKey,
  '@client4': Client4Keys._encryptionPublicKey,
  '@client5': Client5Keys._encryptionPublicKey,
  '@client6': Client6Keys._encryptionPublicKey,
  '@telemetry1': Telemetry1Keys._encryptionPublicKey,
  '@telemetry2': Telemetry2Keys._encryptionPublicKey,
  '@producer1': Producer1Keys._encryptionPublicKey,
  '@producer2': Producer2Keys._encryptionPublicKey,
  '@producer3': Producer3Keys._encryptionPublicKey,
  '@producer4': Producer4Keys._encryptionPublicKey,
  '@producer5': Producer5Keys._encryptionPublicKey,
  '@producer6': Producer6Keys._encryptionPublicKey,
};

/// Map of user's AES keys.
Map<String, String> aesKeyMap = <String, String>{
  '@relay1': Relay1Keys._aesKey,
  '@relay2': Relay2Keys._aesKey,
  '@relay3': Relay3Keys._aesKey,
  '@relay4': Relay4Keys._aesKey,
  '@relay5': Relay5Keys._aesKey,
  '@relay6': Relay6Keys._aesKey,
  '@device1': Device1Keys._aesKey,
  '@cloudvm1': Cloudvm1Keys._aesKey,
  '@gateway1': Gateway1Keys._aesKey,
  '@gateway2': Gateway2Keys._aesKey,
  '@policy1': Policy1Keys._aesKey,
  '@policy2': Policy2Keys._aesKey,
  '@events1': Events1Keys._aesKey,
  '@events2': Events2Keys._aesKey,
  '@device2': Device2Keys._aesKey,
  '@device3': Device3Keys._aesKey,
  '@device4': Device4Keys._aesKey,
  '@device5': Device5Keys._aesKey,
  '@device6': Device6Keys._aesKey,
  '@cloudvm2': Cloudvm2Keys._aesKey,
  '@client1': Client1Keys._aesKey,
  '@client2': Client2Keys._aesKey,
  '@client3': Client3Keys._aesKey,
  '@client4': Client4Keys._aesKey,
  '@client5': Client5Keys._aesKey,
  '@client6': Client6Keys._aesKey,
  '@telemetry1': Telemetry1Keys._aesKey,
  '@telemetry2': Telemetry2Keys._aesKey,
  '@producer1': Producer1Keys._aesKey,
  '@producer2': Producer2Keys._aesKey,
  '@producer3': Producer3Keys._aesKey,
  '@producer4': Producer4Keys._aesKey,
  '@producer5': Producer5Keys._aesKey,
  '@producer6': Producer6Keys._aesKey,
};

// APKAM symmetric keys
Map<String, String> apkamSymmetricKeyMap = <String, String>{
  '@relay1': Relay1Keys._apkamSymmetricKey,
  '@relay2': Relay2Keys._apkamSymmetricKey,
  '@relay3': Relay3Keys._apkamSymmetricKey,
  '@relay4': Relay4Keys._apkamSymmetricKey,
  '@relay5': Relay5Keys._apkamSymmetricKey,
  '@relay6': Relay6Keys._apkamSymmetricKey,
  '@device1': Device1Keys._apkamSymmetricKey,
  '@cloudvm1': Cloudvm1Keys._apkamSymmetricKey,
  '@gateway1': Gateway1Keys._apkamSymmetricKey,
  '@gateway2': Gateway2Keys._apkamSymmetricKey,
  '@policy1': Policy1Keys._apkamSymmetricKey,
  '@policy2': Policy2Keys._apkamSymmetricKey,
  '@events1': Events1Keys._apkamSymmetricKey,
  '@events2': Events2Keys._apkamSymmetricKey,
  '@device2': Device2Keys._apkamSymmetricKey,
  '@device3': Device3Keys._apkamSymmetricKey,
  '@device4': Device4Keys._apkamSymmetricKey,
  '@device5': Device5Keys._apkamSymmetricKey,
  '@device6': Device6Keys._apkamSymmetricKey,
  '@cloudvm2': Cloudvm2Keys._apkamSymmetricKey,
  '@client1': Client1Keys._apkamSymmetricKey,
  '@client2': Client2Keys._apkamSymmetricKey,
  '@client3': Client3Keys._apkamSymmetricKey,
  '@client4': Client4Keys._apkamSymmetricKey,
  '@client5': Client5Keys._apkamSymmetricKey,
  '@client6': Client6Keys._apkamSymmetricKey,
  '@telemetry1': Telemetry1Keys._apkamSymmetricKey,
  '@telemetry2': Telemetry2Keys._apkamSymmetricKey,
  '@producer1': Producer1Keys._apkamSymmetricKey,
  '@producer2': Producer2Keys._apkamSymmetricKey,
  '@producer3': Producer3Keys._apkamSymmetricKey,
  '@producer4': Producer4Keys._apkamSymmetricKey,
  '@producer5': Producer5Keys._apkamSymmetricKey,
  '@producer6': Producer6Keys._apkamSymmetricKey,
};

// APKAM Private Keys
Map<String, String> apkamPrivateKeyMap = <String, String>{
  '@relay1': Relay1Keys._apkamPrivateKey,
  '@relay3': Relay3Keys._apkamPrivateKey,
  '@relay4': Relay4Keys._apkamPrivateKey,
  '@relay5': Relay5Keys._apkamPrivateKey,
  '@relay6': Relay6Keys._apkamPrivateKey,
  '@client1': Client1Keys._apkamPrivateKey,
  '@client2': Client2Keys._apkamPrivateKey,
  '@client3': Client3Keys._apkamPrivateKey,
  '@client4': Client4Keys._apkamPrivateKey,
  '@client5': Client5Keys._apkamPrivateKey,
  '@client6': Client6Keys._apkamPrivateKey,
  '@events1': Events1Keys._apkamPrivateKey,
  '@events2': Events2Keys._apkamPrivateKey,
  '@telemetry1': Telemetry1Keys._apkamPrivateKey,
  '@telemetry2': Telemetry2Keys._apkamPrivateKey,
  '@producer1': Producer1Keys._apkamPrivateKey,
  '@producer2': Producer2Keys._apkamPrivateKey,
  '@producer3': Producer3Keys._apkamPrivateKey,
  '@producer4': Producer4Keys._apkamPrivateKey,
  '@producer5': Producer5Keys._apkamPrivateKey,
  '@producer6': Producer6Keys._apkamPrivateKey,
};

// APKAM Public Keys
Map<String, String> apkamPublicKeyMap = <String, String>{
  '@relay1': Relay1Keys._apkamPublicKey,
  '@relay3': Relay3Keys._apkamPublicKey,
  '@relay4': Relay4Keys._apkamPublicKey,
  '@relay5': Relay5Keys._apkamPublicKey,
  '@relay6': Relay6Keys._apkamPublicKey,
  '@client1': Client1Keys._apkamPublicKey,
  '@client2': Client2Keys._apkamPublicKey,
  '@client3': Client3Keys._apkamPublicKey,
  '@client4': Client4Keys._apkamPublicKey,
  '@client5': Client5Keys._apkamPublicKey,
  '@client6': Client6Keys._apkamPublicKey,
  '@events1': Events1Keys._apkamPublicKey,
  '@events2': Events2Keys._apkamPublicKey,
  '@telemetry1': Telemetry1Keys._apkamPublicKey,
  '@telemetry2': Telemetry2Keys._apkamPublicKey,
  '@producer1': Producer1Keys._apkamPublicKey,
  '@producer2': Producer2Keys._apkamPublicKey,
  '@producer3': Producer3Keys._apkamPublicKey,
  '@producer4': Producer4Keys._apkamPublicKey,
  '@producer5': Producer5Keys._apkamPublicKey,
  '@producer6': Producer6Keys._apkamPublicKey,
};
