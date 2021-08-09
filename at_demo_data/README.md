# at_demo_data
This library contains data that can be used for demo apps and testing.

## Installation:
To use this library in your app, first add it to your pubspec.yaml

```yaml
dependencies:
  at_demo_data: ^0.0.4
```

### Add to your project 
```bash
pub get 
```

### Import in your application code
```dart
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
```

## Usage

### How to retrieve test environment values
```dart
// Production environment
String prodRoot = at_demo_data.prodRoot;
int prodPort = at_demo_data.prodPort;

// Local environment
String virtualRoot = at_demo_data.virtualRoot;
int virtualPort = at_demo_data.virtualPort;
```

### How to access sample data:
```dart
// List of all atsigns
List<String> atSigns = at_demo_data.allAtsigns;

// PKAM public key String for a particular @sign can be retrieved from 
// the pkamPublicKeyMap
String pkamPublicKey = at_demo_data.pkamPublicKeyMap['@alice🛠'];

// PKAM private key String for a particular @sign can be retrieved from 
// the pkamPrivateKeyMap
String pkamPrivate = at_demo_data.pkamPrivateKeyMap['@alice🛠'];

// CRAM key String for a particular @sign can be retrieved from 
// the cramKeyMap
String cramKey = at_demo_data.cramKeyMap['@alice🛠'];
```
