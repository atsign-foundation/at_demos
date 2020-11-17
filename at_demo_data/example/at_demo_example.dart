import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import "dart:math";

/// demo @signs
///
/// List all @signs
List<String> allAtsigns = at_demo_data.allAtsigns;

/// Get a random @sign
final _random = new Random();
String randomAtsign = at_demo_data.allAtsigns[_random.nextInt(at_demo_data.allAtsigns.length)];

/// demo keys
///
/// CRAM keys
///
/// CRAM keys Map
Map cramKeyMap = at_demo_data.cramKeyMap;

/// get CRAM key for an @sign
String cramKey = cramKeyMap[randomAtsign];

/// PKAM keys
///
/// PKAM public keys
///
/// PKAM public keys Map
Map pkamPublicKeyMap = at_demo_data.pkamPublicKeyMap;

/// get PKAM public key for an @sign
String pkamPublicKey = pkamPublicKeyMap[randomAtsign];

/// PKAM private keys
///
/// PKAM private keys Map
Map pkamPrivateKeyMap = at_demo_data.pkamPrivateKeyMap;

/// get PKAM private key for an @sign
String pkamPrivateKey = pkamPrivateKeyMap[randomAtsign];
