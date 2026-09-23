# at_demo_data

<!---
Adding the atPlatform logos gives a nice look for your readme
-->
<a href="https://atsign.com#gh-light-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2022/05/atsign-logo-horizontal-color2022.svg#gh-light-mode-only" alt="The Atsign Foundation"></a><a href="https://atsign.com#gh-dark-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2023/08/atsign-logo-horizontal-reverse2022-Color.svg#gh-dark-mode-only" alt="The Atsign Foundation"></a>

<!---
Add a badge bar for your package by replacing at_demo_data below with
your package name below and at_client_sdk with the name of the repo
-->
[![pub package](https://img.shields.io/pub/v/at_demo_data)](https://pub.dev/packages/at_demo_data) [![pub points](https://img.shields.io/pub/points/at_demo_data?logo=dart)](https://pub.dev/packages/at_demo_data/score)  [![gitHub license](https://img.shields.io/badge/license-BSD3-blue.svg)](./LICENSE)

<!--- this is a table version
| [![pub package](https://img.shields.io/pub/v/at_demo_data)](https://pub.dev/packages/at_demo_data) | [![pub points](https://badges.bar/at_demo_data/pub%20points)](https://pub.dev/packages/at_demo_data/score) | [![build status](https://github.com/atsign-foundation/at_client_sdk/actions/workflows/at_client_sdk.yaml/badge.svg?branch=trunk)](https://github.com/atsign-foundation/at_client_sdk/actions/workflows/at_client_sdk.yaml) | [![gitHub license](https://img.shields.io/badge/license-BSD3-blue.svg)](./LICENSE)
|------|------|------|------|------| 
-->
## Overview
<!---
## Who is this for?
The README should be addressed to somebody who's never seen this before.
But also don't assume that they're a novice.
-->
The at_demo_data package provides credentials for demo Atsigns in the [Virtual Environment (VE)](https://atsign.dev/docs/get-started/the-virtual-environment/). The included Atsigns are ASCII-only. These credentials are test fixtures, not production secrets. A VE image must be provisioned with matching CRAM secrets and public keys; changing files in this package does not rotate an already-running VE.

<!---
Give some context and state the intent - we welcome contributions - we want
pull requests and to hear about issues. Include the boilerplate language
below to add some context to atPlatform packages 
-->
This open source package is written in Dart, supports Flutter and follows the
atPlatform's decentralized, edge computing model with the following features: 
- Cryptographic control of data access through personal data stores
- No application backend needed
- End to end encryption where only the data owner has the keys
- Private and surveillance free connectivity
 <!--- add package features here -->

We call giving people control of access to their data “flipping the internet”
and you can learn more about how it works by reading this
[overview](https://atsign.com/flip-the-internet/).

<!---
Does this package publish to pub.dev or similar? This README will be the
first thing that developers see there and should be written such that it
lets them quickly assess if it fits their need.
-->
## Get started
There are two options to get started using this package.

<!---
If the package has a template that at_app uses to generate a skeleton app,
that is the quickest way for a developer to assess it and get going with
their app.
-->

<!---
Cloning the repo and example app from GitHub is the next option for a
developer to get started.
-->
### 1. Clone it from GitHub
<!---
Make sure to edit the link below to refer to your package repo.
-->
Feel free to fork a copy of the source from the [GitHub repo](https://github.com/atsign-foundation/at_demos). The example code contained there is the same as the template that is used by at_app above.

```sh
$ git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
```

<!---
The last option is to use the traditionaL instructions for adding the package to a project which can be found on pub.dev. 
Please be sure to replace the package name in the url below the right one for this package.
-->
### 2. Manually add the package to a project

Instructions on how to manually add this package to you project can be found on pub.dev [here](https://pub.dev/packages/at_demo_data/install).


<!---
Add details on how to use the package in an application
-->

### Usage

<!---
Make sure your source code annotations are clear and comprehensive.
-->
For more information, please see the API documentation listed on pub.dev.

<!---
If we have any pages for these docs on atsign.dev site, it would be 
good to add links.(optional)
-->

#### How to retrieve test environment values
```dart
// Production environment
String prodRoot = at_demo_data.prodRoot;
int prodPort = at_demo_data.prodPort;

// Local environment
String virtualRoot = at_demo_data.virtualRoot;
int virtualPort = at_demo_data.virtualPort;
```

The legacy VE fixtures include `@client1`, `@client2`, `@telemetry1`,
`@telemetry2`, and `@producer1` through `@producer5`. Every listed Atsign
except `anonymous`, including APKAM-only fixtures, has a matching file in
`lib/assets/atkeys/`. The APKAM-only fixtures must still be enrolled before
those files can be used for APKAM authentication.

#### How to access sample data:
```dart
// List of all atsigns
List<String> atSigns = at_demo_data.allAtsigns;

// PKAM public key String for a particular atSign can be retrieved from 
// the pkamPublicKeyMap
String pkamPublicKey = at_demo_data.pkamPublicKeyMap['@relay1'];

// PKAM private key String for a particular atSign can be retrieved from 
// the pkamPrivateKeyMap
String pkamPrivate = at_demo_data.pkamPrivateKeyMap['@relay1'];

// CRAM key String for a particular atSign can be retrieved from 
// the cramKeyMap
String cramKey = at_demo_data.cramKeyMap['@relay1'];
```

<!---
You should include language like below if you would like others to contribute
to your package.
-->
### Generate credentials for a new VE Atsign

From `packages/at_demo_data`, run:

```sh
dart pub get
dart run tools/generate_ve_atsign.dart @newdemo /path/to/new-private-directory legacy
# For an APKAM identity instead, use a different Atsign and directory:
dart run tools/generate_ve_atsign.dart @newapkam /path/to/another-private-directory apkam
```

The destination must not exist. The tool creates it with owner-only permissions and writes `@newdemo.atKeys`, `@newdemo.ve-credentials.json`, and `newdemo_keys.dart` with owner-only file permissions. It generates a new CRAM secret, separate RSA key pairs for PKAM, encryption, and APKAM, a self-encryption AES key, and symmetric keys. It never prints secrets to the terminal and refuses to overwrite an existing destination. Keep these files private and do not commit them unless they are intentionally public VE-only fixtures.

To add the Atsign to this package, copy its generated `_keys.dart` file into `lib/src/constants/`, add the matching `part 'constants/<name>_keys.dart';` to `lib/src/at_demo_credentials.dart`, and add its class fields to the credential maps. The JSON bundle records the requested `authMode`. For `legacy`, put the Atsign in `allAtsigns`; VE setup authenticates with its `cramKey` and installs its `pkamPublicKey` and `encryptionPublicKey`. For `apkam`, put it in `apkamAtsigns` instead; VE setup creates the secondary and authenticates by CRAM only, leaving APKAM enrollment to the client. Both modes require the generated `cramKey` when the VE creates the secondary. The generated `.atKeys` does not itself enroll an APKAM identity or register an Atsign. The VE setup scripts read `at_demo_data` when building the image, so rebuild and restart with matching package credentials. An already-provisioned Atsign requires a coordinated rotation, not just this generation command.

## Open source usage and contributions
This is open source code, so feel free to use it as is, suggest changes or 
enhancements or create your own version. See [CONTRIBUTING.md](CONTRIBUTING.md) 
for detailed guidance on how to setup tools, tests and make a pull request.

<!---
Have we correctly acknowledged the work of others (and their Trademarks etc.)
where appropriate (per the conditions of their LICENSE?
-->
<!-- ## Acknowledgement/attribution -->

<!---
Who created this?  
Do they have complete GitHub profiles?  
How can they be contacted?  
Who is going to respond to pull requests?  
-->
<!-- ## Maintainers -->

<!---
## Checklist

- [ ] Writing and style
Does the writing flow, with proper grammar and correct spelling?

- [ ] SEO
Always keep in mind that developers will often use search to find solutions
to their needs. Make sure and add in terms that will help get this package to
the top of the search results for google, pub.dev and medium.com as a minimum.

- [ ] Links
Are the links to external resources correct?
Are the links to other parts of the project correct
(beware stuff carried over from previous repos where the
project might have lived during earlier development)?

- [ ] LICENSE
Which LICENSE are we using?  
Is the LICENSE(.md) file present?  
Does it have the correct dates, legal entities etc.?
-->
