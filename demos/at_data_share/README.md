<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

The AtData Share command line application facilitates the exchange of data between two atSigns, allowing users to share a wide range of information, including text and media files.

## Features

AtData Share stands out from other data-sharing applications by offering a distinct capability: atSign users can send targeted data requests to other atSign users. For instance, an employer can send a JSON schema to a candidate, specifying the desired information such as name, current employer, current salary, and skill set. The candidate receives the JSON schema, fills it with the requested details, and sends it back to the employer. This unique feature enables efficient and structured data exchange between parties.

## Getting started

In the given scenario, two atSigns are engaged in a data exchange. The first atSign initiates a request and sends it to the second atSign. Upon receiving the request, the second atSign fulfills the requested data and sends it back to the first atSign. This two-way interaction enables effective data sharing between the atSign users.
## Usage

To begin the data sharing process, the atSign that will fulfill the request needs to be started first.

```dart
dart bin/main.dart -a @bob -d receiveData
```

Then, run bin/main.dart as below to send a request to the above atSign.

```dart
dart bin/main.dart -a @alice -d requestData
```
Once, the request is received by the first atSign, run "fulfil_request.dart" in "test/samples" to fulfil the request.


## Limitations

At present, the main.dart file contains hardcoded information regarding the atSign to which the request must be sent and the specific details to be requested.

## Additional information

The Users can fetch the sent and received requests using the "get_received_requests.dart" and "get_sent_requests.dart" in "test/samples" folder.
