<img src="https://atsign.dev/assets/img/@developersmall.png?sanitize=true">

### Now for a little internet optimism

# at_demo_data
This library contains data that can be used for demo apps and testing when using
[The Virtual Environment (VE)](https://atsign.dev/docs/get-started/the-virtual-environment/)
which provides a full stack private @ enviroment to build and test applications offline. 
A number of preset @signs are included in the VE and the secrets and keys are provided in this repo
for those test @signs.




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
