## 2.0.0

- **Feat**: Added legacy VE fixtures for `@relay3` through `@relay6`,
  `@device3` through `@device6`, `@client1` through `@client6`, `@events1`,
  `@events2`, `@telemetry1`, `@telemetry2`, and `@producer1` through
  `@producer6`.
- **Fix**: Bundled matching `.atKeys` files for every active Atsign, corrected
  `@policy1`'s filename, and regenerated the stale `@device2` file from its
  existing credential maps. Added asset and key-pair consistency tests.
- **Feat**: Added a VE credential generator for private `.atKeys`, CRAM,
  asymmetric and symmetric keys, and a per-Atsign Dart constants file. The
  required legacy or APKAM mode records the intended VE provisioning path.
- **Refactor**: Moved credential classes into `lib/src/constants/`, one file
  per Atsign. Updated the example and usage instructions.
- **BREAKING CHANGE**: Removed demo Atsigns with emoji, their credential entries,
  bundled key files, QR codes, and emoji-only credential lists.
- **BREAKING CHANGE**: Removed `@colin`, `@barbara`, `@curtly`, `@denise`,
  `@don`, `@gareth`, `@gary`, `@jeremy`, `@xavier`, `@chris`, `@srie`, and
  `@sachin` and their credentials.

## 1.2.0

- **Feat**: Duplicated demo keys with different atSigns (cycle 2). If necessary,
  these cycles are marked if for some reason unique keys must be used for a
  demo.

## 1.1.0

- **Fix** Added "apkamPrivateKeyMap" and "apkamPublicKeyMap" to fetch APKAM keys

## 1.0.3

- **Fix**: Fixed duplicate cram keys for apkam atsigns

## 1.0.2

- **Feat**: Added demo atsigns for apkam

## 1.0.1

- **Feat**: Added demo credentials for apkam symmetric key
- **Chore**: Updated documentation.
- **Feat**: Added atkey files for demo atsigns.

## 1.0.0

- **BREAKING CHANGE**: Support for sound null-safety.
- **Feat**: Re-arranged all the Keys according to the user's names in classes.

## 0.0.3+1

- **Feat**: Added aesKeyMap.

## 0.0.2+1

- **Chore**: Ensure example gets found by pub.dev.

## 0.0.2

- **Chore**: Matching up versions in the docs.

## 0.0.1

- Initial release.
