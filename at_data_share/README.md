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

The AtData Share is a command line application with which data can be shared between two atSign's.
The data can be anything from a simple text to media.

## Features

AtData share is different from other data sharing applications where an atSign user can send a request to other atSign user for a specific data.

For example, if an employer wants the candidate's profile information like name, current employer, current salary, skill set etc., then the employer sends a JSON schema (where key's represent the details the employer is looking for like name, current employer.. and values will be placeholder for the candidate to fill)
with the details to the candidate. The candidate upon receiving the JSON, fills the JSON with the details and sends back to the employer

## Getting started

We need two atSign where one atSign sends a request to the other atSign.
The second atSign upon receiving the request, fulfils the request and sends it back to the first atSign.

## Usage

First, start the atSign who would serve the request.

```dart
dart bin/main.dart -a @bob -d receiveData
```

Then, run bin/main.dart as below to send a request to above atSign. 

```dart
dart bin/main.dart -a @alice -d requestData
```
Once, the request is received to first atSign, run "fulful_request.dart" in "test/samples" to fulfil the request.

## Limitations

Currently, the atSign to whom the request has to sent and the details to request are hard-coded in the main.dart file.

## Additional information

The Users can fetch the send and received requests using the "get_received_requests.dart" and "get_sent_requests.dart" in "test/samples" folder.
