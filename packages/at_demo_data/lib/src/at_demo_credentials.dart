library at_demo_data.at_demo_credentials;

part 'at_demo_keys.dart';
part 'at_demo_apkam_keys.dart';

/// List of all demo At-Signs.
List<String> allAtsigns = <String>[
  'anonymous',           // 0
  // Key cycle 1 (keys are reused across each cycle)
  '@alice🛠',           // 1
  '@ashish🛠',          // 2
  '@barbara🛠',         // 3
  '@bob🛠',             // 4
  '@colin🛠',           // 5
  '@egbiometric🛠',     // 6
  '@egcovidlab🛠',      // 7
  '@egcreditbureau🛠',  // 8
  '@eggovagency🛠',     // 9
  '@emoji🦄🛠',         // 10
  '@eve🛠',             // 11
  '@jagan🛠',           // 12
  '@kevin🛠',           // 13
  '@murali🛠',          // 14
  '@naresh🛠',          // 15
  '@purnima🛠',         // 16
  '@sameeraja🛠',       // 17
  '@sitaram🛠',         // 18
  // Key cycle 2
  '@relay1',            // 19
  '@relay2',            // 20
  '@device1',           // 21
  '@cloudvm1',          // 22
  '@gateway1',          // 23
  '@gateway2',          // 24
  '@policy1',           // 25
  '@policy2',           // 26
  '@colin',             // 27
  '@barbara',           // 28
  '@chris',             // 29
  '@gary',              // 30
  '@xavier',            // 31
  '@jeremy',            // 32
  '@curtly',            // 33
  '@gareth',            // 34
  '@don',               // 35
  '@denise',            // 36
];

/// List of atsigns to test APKAM feature
List<String> apkamAtsigns = <String>[
  // Key cycle 1
  '@srie',
  '@sachin',
  // Key cycle 2
  '@device2',
  '@cloudvm2',
];

/// A Map of cram (Challenge Response Authentication Mechanism) keys.
/// For more information on CRAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#cram)
Map<String, String> cramKeyMap = <String, String>{
  'anonymous': '',
  // Cycle 1
  '@alice🛠': AliceKeys._cramKey,
  '@ashish🛠': AshishKeys._cramKey,
  '@barbara🛠': BarbaraKeys._cramKey,
  '@bob🛠': BobKeys._cramKey,
  '@colin🛠': ColinKeys._cramKey,
  '@egbiometric🛠': EgBiometricKeys._cramKey,
  '@egcovidlab🛠': EgCovidLabKeys._cramKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._cramKey,
  '@eggovagency🛠': EgGovAgencyKeys._cramKey,
  '@emoji🦄🛠': EmojiKeys._cramKey,
  '@eve🛠': EveKeys._cramKey,
  '@jagan🛠': JaganKeys._cramKey,
  '@kevin🛠': KevinKeys._cramKey,
  '@murali🛠': MuraliKeys._cramKey,
  '@naresh🛠': NareshKeys._cramKey,
  '@purnima🛠': PurnimaKeys._cramKey,
  '@sameeraja🛠': SameerajaKeys._cramKey,
  '@sitaram🛠': SitaramKeys._cramKey,
  '@srie': SrieKeys._cramKey,
  '@sachin': SachinKeys._cramKey,
  // Cycle 2
  '@relay1': Relay1Keys._cramKey,
  '@relay2': Relay2Keys._cramKey,
  '@device1': Device1Keys._cramKey,
  '@cloudvm1': Cloudvm1Keys._cramKey,
  '@gateway1': Gateway1Keys._cramKey,
  '@gateway2': Gateway2Keys._cramKey,
  '@policy1': Policy1Keys._cramKey,
  '@policy2': Policy2Keys._cramKey,
  '@colin': EmojilessColinKeys._cramKey,
  '@barbara': EmojilessBarbaraKeys._cramKey,
  '@chris': ChrisKeys._cramKey,
  '@gary': GaryKeys._cramKey,
  '@xavier': XavierKeys._cramKey,
  '@jeremy': JeremyKeys._cramKey,
  '@curtly': CurtlyKeys._cramKey,
  '@gareth': GarethKeys._cramKey,
  '@don': DonKeys._cramKey,
  '@denise': DeniseKeys._cramKey,
  '@device2': Device2Keys._cramKey,
  '@cloudvm2': Cloudvm2Keys._cramKey,
};

/// Map of user's public pkam( Public Key Authentication Mechanism) keys.
/// For more information on PKAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#pkam)
Map<String, String> pkamPublicKeyMap = <String, String>{
  'anonymous': '',
  '@alice🛠': AliceKeys._pkamPublicKey,
  '@ashish🛠': AshishKeys._pkamPublicKey,
  '@barbara🛠': BarbaraKeys._pkamPublicKey,
  '@bob🛠': BobKeys._pkamPublicKey,
  '@colin🛠': ColinKeys._pkamPublicKey,
  '@egbiometric🛠': EgBiometricKeys._pkamPublicKey,
  '@egcovidlab🛠': EgCovidLabKeys._pkamPublicKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._pkamPublicKey,
  '@eggovagency🛠': EgGovAgencyKeys._pkamPublicKey,
  '@emoji🦄🛠': EmojiKeys._pkamPublicKey,
  '@eve🛠': EveKeys._pkamPublicKey,
  '@jagan🛠': JaganKeys._pkamPublicKey,
  '@kevin🛠': KevinKeys._pkamPublicKey,
  '@murali🛠': MuraliKeys._pkamPublicKey,
  '@naresh🛠': NareshKeys._pkamPublicKey,
  '@purnima🛠': PurnimaKeys._pkamPublicKey,
  '@sameeraja🛠': SameerajaKeys._pkamPublicKey,
  '@sitaram🛠': SitaramKeys._pkamPublicKey,
  '@srie': SrieKeys._pkamPublicKey,
  '@sachin': SachinKeys._pkamPublicKey,
  // Cycle 2
  '@relay1': Relay1Keys._pkamPublicKey,
  '@relay2': Relay2Keys._pkamPublicKey,
  '@device1': Device1Keys._pkamPublicKey,
  '@cloudvm1': Cloudvm1Keys._pkamPublicKey,
  '@gateway1': Gateway1Keys._pkamPublicKey,
  '@gateway2': Gateway2Keys._pkamPublicKey,
  '@policy1': Policy1Keys._pkamPublicKey,
  '@policy2': Policy2Keys._pkamPublicKey,
  '@colin': EmojilessColinKeys._pkamPublicKey,
  '@barbara': EmojilessBarbaraKeys._pkamPublicKey,
  '@chris': ChrisKeys._pkamPublicKey,
  '@gary': GaryKeys._pkamPublicKey,
  '@xavier': XavierKeys._pkamPublicKey,
  '@jeremy': JeremyKeys._pkamPublicKey,
  '@curtly': CurtlyKeys._pkamPublicKey,
  '@gareth': GarethKeys._pkamPublicKey,
  '@don': DonKeys._pkamPublicKey,
  '@denise': DeniseKeys._pkamPublicKey,
  '@device2': Device2Keys._pkamPublicKey,
  '@cloudvm2': Cloudvm2Keys._pkamPublicKey,
};

/// Map of user's private pkam( Public Key Authentication Mechanism) keys.
/// For more information on PKAM, see: [here](https://atsign.dev/docs/functional_architecture/verbs/#pkam)
Map<String, String> pkamPrivateKeyMap = <String, String>{
  'anonymous': '',
  '@alice🛠': AliceKeys._pkamPrivateKey,
  '@ashish🛠': AshishKeys._pkamPrivateKey,
  '@barbara🛠': BarbaraKeys._pkamPrivateKey,
  '@bob🛠': BobKeys._pkamPrivateKey,
  '@colin🛠': ColinKeys._pkamPrivateKey,
  '@egbiometric🛠': EgBiometricKeys._pkamPrivateKey,
  '@egcovidlab🛠': EgCovidLabKeys._pkamPrivateKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._pkamPrivateKey,
  '@eggovagency🛠': EgGovAgencyKeys._pkamPrivateKey,
  '@emoji🦄🛠': EmojiKeys._pkamPrivateKey,
  '@eve🛠': EveKeys._pkamPrivateKey,
  '@jagan🛠': JaganKeys._pkamPrivateKey,
  '@kevin🛠': KevinKeys._pkamPrivateKey,
  '@murali🛠': MuraliKeys._pkamPrivateKey,
  '@naresh🛠': NareshKeys._pkamPrivateKey,
  '@purnima🛠': PurnimaKeys._pkamPrivateKey,
  '@sameeraja🛠': SameerajaKeys._pkamPrivateKey,
  '@sitaram🛠': SitaramKeys._pkamPrivateKey,
  '@srie': SrieKeys._pkamPrivateKey,
  '@sachin': SachinKeys._pkamPrivateKey,
  // Cycle 2
  '@relay1': Relay1Keys._pkamPrivateKey,
  '@relay2': Relay2Keys._pkamPrivateKey,
  '@device1': Device1Keys._pkamPrivateKey,
  '@cloudvm1': Cloudvm1Keys._pkamPrivateKey,
  '@gateway1': Gateway1Keys._pkamPrivateKey,
  '@gateway2': Gateway2Keys._pkamPrivateKey,
  '@policy1': Policy1Keys._pkamPrivateKey,
  '@policy2': Policy2Keys._pkamPrivateKey,
  '@colin': EmojilessColinKeys._pkamPrivateKey,
  '@barbara': EmojilessBarbaraKeys._pkamPrivateKey,
  '@chris': ChrisKeys._pkamPrivateKey,
  '@gary': GaryKeys._pkamPrivateKey,
  '@xavier': XavierKeys._pkamPrivateKey,
  '@jeremy': JeremyKeys._pkamPrivateKey,
  '@curtly': CurtlyKeys._pkamPrivateKey,
  '@gareth': GarethKeys._pkamPrivateKey,
  '@don': DonKeys._pkamPrivateKey,
  '@denise': DeniseKeys._pkamPrivateKey,
  '@device2': Device2Keys._pkamPrivateKey,
  '@cloudvm2': Cloudvm2Keys._pkamPrivateKey,
};

/// Map of user's private encryption keys.
Map<String, String> encryptionPrivateKeyMap = <String, String>{
  'anonymous': '',
  '@alice🛠': AliceKeys._encryptionPrivateKey,
  '@ashish🛠': AshishKeys._encryptionPrivateKey,
  '@barbara🛠': BarbaraKeys._encryptionPrivateKey,
  '@bob🛠': BobKeys._encryptionPrivateKey,
  '@colin🛠': ColinKeys._encryptionPrivateKey,
  '@egbiometric🛠': EgBiometricKeys._encryptionPrivateKey,
  '@egcovidlab🛠': EgCovidLabKeys._encryptionPrivateKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._encryptionPrivateKey,
  '@eggovagency🛠': EgGovAgencyKeys._encryptionPrivateKey,
  '@emoji🦄🛠': EmojiKeys._encryptionPrivateKey,
  '@eve🛠': EveKeys._encryptionPrivateKey,
  '@jagan🛠': JaganKeys._encryptionPrivateKey,
  '@kevin🛠': KevinKeys._encryptionPrivateKey,
  '@murali🛠': MuraliKeys._encryptionPrivateKey,
  '@naresh🛠': NareshKeys._encryptionPrivateKey,
  '@purnima🛠': PurnimaKeys._encryptionPrivateKey,
  '@sameeraja🛠': SameerajaKeys._encryptionPrivateKey,
  '@sitaram🛠': SitaramKeys._encryptionPrivateKey,
  '@srie': SrieKeys._encryptionPrivateKey,
  '@sachin': SachinKeys._encryptionPrivateKey,
  // Cycle 2
  '@relay1': Relay1Keys._encryptionPrivateKey,
  '@relay2': Relay2Keys._encryptionPrivateKey,
  '@device1': Device1Keys._encryptionPrivateKey,
  '@cloudvm1': Cloudvm1Keys._encryptionPrivateKey,
  '@gateway1': Gateway1Keys._encryptionPrivateKey,
  '@gateway2': Gateway2Keys._encryptionPrivateKey,
  '@policy1': Policy1Keys._encryptionPrivateKey,
  '@policy2': Policy2Keys._encryptionPrivateKey,
  '@colin': EmojilessColinKeys._encryptionPrivateKey,
  '@barbara': EmojilessBarbaraKeys._encryptionPrivateKey,
  '@chris': ChrisKeys._encryptionPrivateKey,
  '@gary': GaryKeys._encryptionPrivateKey,
  '@xavier': XavierKeys._encryptionPrivateKey,
  '@jeremy': JeremyKeys._encryptionPrivateKey,
  '@curtly': CurtlyKeys._encryptionPrivateKey,
  '@gareth': GarethKeys._encryptionPrivateKey,
  '@don': DonKeys._encryptionPrivateKey,
  '@denise': DeniseKeys._encryptionPrivateKey,
  '@device2': Device2Keys._encryptionPrivateKey,
  '@cloudvm2': Cloudvm2Keys._encryptionPrivateKey,
};

/// Map of user's public encryption keys.
Map<String, String> encryptionPublicKeyMap = <String, String>{
  'anonymous': '',
  '@alice🛠': AliceKeys._encryptionPublicKey,
  '@ashish🛠': AshishKeys._encryptionPublicKey,
  '@barbara🛠': BarbaraKeys._encryptionPublicKey,
  '@bob🛠': BobKeys._encryptionPublicKey,
  '@colin🛠': ColinKeys._encryptionPublicKey,
  '@egbiometric🛠': EgBiometricKeys._encryptionPublicKey,
  '@egcovidlab🛠': EgCovidLabKeys._encryptionPublicKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._encryptionPublicKey,
  '@eggovagency🛠': EgGovAgencyKeys._encryptionPublicKey,
  '@emoji🦄🛠': EmojiKeys._encryptionPublicKey,
  '@eve🛠': EveKeys._encryptionPublicKey,
  '@jagan🛠': JaganKeys._encryptionPublicKey,
  '@kevin🛠': KevinKeys._encryptionPublicKey,
  '@murali🛠': MuraliKeys._encryptionPublicKey,
  '@naresh🛠': NareshKeys._encryptionPublicKey,
  '@purnima🛠': PurnimaKeys._encryptionPublicKey,
  '@sameeraja🛠': SameerajaKeys._encryptionPublicKey,
  '@sitaram🛠': SitaramKeys._encryptionPublicKey,
  '@srie': SrieKeys._encryptionPublicKey,
  '@sachin': SachinKeys._encryptionPublicKey,
  // Cycle 2
  '@relay1': Relay1Keys._encryptionPublicKey,
  '@relay2': Relay2Keys._encryptionPublicKey,
  '@device1': Device1Keys._encryptionPublicKey,
  '@cloudvm1': Cloudvm1Keys._encryptionPublicKey,
  '@gateway1': Gateway1Keys._encryptionPublicKey,
  '@gateway2': Gateway2Keys._encryptionPublicKey,
  '@policy1': Policy1Keys._encryptionPublicKey,
  '@policy2': Policy2Keys._encryptionPublicKey,
  '@colin': EmojilessColinKeys._encryptionPublicKey,
  '@barbara': EmojilessBarbaraKeys._encryptionPublicKey,
  '@chris': ChrisKeys._encryptionPublicKey,
  '@gary': GaryKeys._encryptionPublicKey,
  '@xavier': XavierKeys._encryptionPublicKey,
  '@jeremy': JeremyKeys._encryptionPublicKey,
  '@curtly': CurtlyKeys._encryptionPublicKey,
  '@gareth': GarethKeys._encryptionPublicKey,
  '@don': DonKeys._encryptionPublicKey,
  '@denise': DeniseKeys._encryptionPublicKey,
  '@device2': Device2Keys._encryptionPublicKey,
  '@cloudvm2': Cloudvm2Keys._encryptionPublicKey,
};

/// Map of user's AES keys.
Map<String, String> aesKeyMap = <String, String>{
  '@alice🛠': AliceKeys._aesKey,
  '@ashish🛠': AshishKeys._aesKey,
  '@barbara🛠': BarbaraKeys._aesKey,
  '@bob🛠': BobKeys._aesKey,
  '@colin🛠': ColinKeys._aesKey,
  '@egbiometric🛠': EgBiometricKeys._aesKey,
  '@egcovidlab🛠': EgCovidLabKeys._aesKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._aesKey,
  '@eggovagency🛠': EgGovAgencyKeys._aesKey,
  '@emoji🦄🛠': EmojiKeys._aesKey,
  '@eve🛠': EveKeys._aesKey,
  '@jagan🛠': JaganKeys._aesKey,
  '@kevin🛠': KevinKeys._aesKey,
  '@murali🛠': MuraliKeys._aesKey,
  '@naresh🛠': NareshKeys._aesKey,
  '@purnima🛠': PurnimaKeys._aesKey,
  '@sameeraja🛠': SameerajaKeys._aesKey,
  '@sitaram🛠': SitaramKeys._aesKey,
  '@srie': SrieKeys._aesKey,
  '@sachin': SachinKeys._aesKey,
  // Cycle 2
  '@relay1': Relay1Keys._aesKey,
  '@relay2': Relay2Keys._aesKey,
  '@device1': Device1Keys._aesKey,
  '@cloudvm1': Cloudvm1Keys._aesKey,
  '@gateway1': Gateway1Keys._aesKey,
  '@gateway2': Gateway2Keys._aesKey,
  '@policy1': Policy1Keys._aesKey,
  '@policy2': Policy2Keys._aesKey,
  '@colin': EmojilessColinKeys._aesKey,
  '@barbara': EmojilessBarbaraKeys._aesKey,
  '@chris': ChrisKeys._aesKey,
  '@gary': GaryKeys._aesKey,
  '@xavier': XavierKeys._aesKey,
  '@jeremy': JeremyKeys._aesKey,
  '@curtly': CurtlyKeys._aesKey,
  '@gareth': GarethKeys._aesKey,
  '@don': DonKeys._aesKey,
  '@denise': DeniseKeys._aesKey,
  '@device2': Device2Keys._aesKey,
  '@cloudvm2': Cloudvm2Keys._aesKey,
};

// APKAM symmetric keys
Map<String, String> apkamSymmetricKeyMap = <String, String>{
  '@alice🛠': AliceKeys._apkamSymmetricKey,
  '@ashish🛠': AshishKeys._apkamSymmetricKey,
  '@barbara🛠': BarbaraKeys._apkamSymmetricKey,
  '@bob🛠': BobKeys._apkamSymmetricKey,
  '@colin🛠': ColinKeys._apkamSymmetricKey,
  '@egbiometric🛠': EgBiometricKeys._apkamSymmetricKey,
  '@egcovidlab🛠': EgCovidLabKeys._apkamSymmetricKey,
  '@egcreditbureau🛠': EgCreditBureauKeys._apkamSymmetricKey,
  '@eggovagency🛠': EgGovAgencyKeys._apkamSymmetricKey,
  '@emoji🦄🛠': EmojiKeys._apkamSymmetricKey,
  '@eve🛠': EveKeys._apkamSymmetricKey,
  '@jagan🛠': JaganKeys._apkamSymmetricKey,
  '@kevin🛠': KevinKeys._apkamSymmetricKey,
  '@murali🛠': MuraliKeys._apkamSymmetricKey,
  '@naresh🛠': NareshKeys._apkamSymmetricKey,
  '@purnima🛠': PurnimaKeys._apkamSymmetricKey,
  '@sameeraja🛠': SameerajaKeys._apkamSymmetricKey,
  '@sitaram🛠': SitaramKeys._apkamSymmetricKey,
  '@srie': SrieKeys._apkamSymmetricKey,
  '@sachin': SachinKeys._apkamSymmetricKey,
  // Cycle 2
  '@relay1': Relay1Keys._apkamSymmetricKey,
  '@relay2': Relay2Keys._apkamSymmetricKey,
  '@device1': Device1Keys._apkamSymmetricKey,
  '@cloudvm1': Cloudvm1Keys._apkamSymmetricKey,
  '@gateway1': Gateway1Keys._apkamSymmetricKey,
  '@gateway2': Gateway2Keys._apkamSymmetricKey,
  '@policy1': Policy1Keys._apkamSymmetricKey,
  '@policy2': Policy2Keys._apkamSymmetricKey,
  '@colin': EmojilessColinKeys._apkamSymmetricKey,
  '@barbara': EmojilessBarbaraKeys._apkamSymmetricKey,
  '@chris': ChrisKeys._apkamSymmetricKey,
  '@gary': GaryKeys._apkamSymmetricKey,
  '@xavier': XavierKeys._apkamSymmetricKey,
  '@jeremy': JeremyKeys._apkamSymmetricKey,
  '@curtly': CurtlyKeys._apkamSymmetricKey,
  '@gareth': GarethKeys._apkamSymmetricKey,
  '@don': DonKeys._apkamSymmetricKey,
  '@denise': DeniseKeys._apkamSymmetricKey,
  '@device2': Device2Keys._apkamSymmetricKey,
  '@cloudvm2': Cloudvm2Keys._apkamSymmetricKey,
};

// APKAM Private Keys
Map<String, String> apkamPrivateKeyMap = <String, String>{
  '@alice🛠': AliceKeys._apkamPrivateKey,
  // Cycle 2
  '@relay1': Relay1Keys._apkamPrivateKey,
};

// APKAM Public Keys
Map<String, String> apkamPublicKeyMap = <String, String>{
  '@alice🛠': AliceKeys._apkamPublicKey,
  // Cycle 2
  '@relay1': Relay1Keys._apkamPublicKey,
};
