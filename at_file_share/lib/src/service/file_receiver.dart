import 'dart:convert';
import 'dart:io';

import 'package:at_client/at_client.dart';

class FileReceiver {
  final AtClient _atClient;

  FileReceiver(this._atClient);

  Future<void> receiveFile(String downloadPath) async {
    _atClient.notificationService
        .subscribe()
        .listen((AtNotification atNotification) async {
      if (atNotification.id != '-1') {
        print('notification Received: ${atNotification.toString()}');
        var key = atNotification.key;
        var atValue = await _atClient.get(AtKey.fromString(key));
        print(atValue.toString());
        var valueJson = jsonDecode(atValue.value);
        var storjUrl = valueJson['fileUrl'];
        var fileDecryptionKey = valueJson['fileEncryptionKey'];
        var chunkSize = valueJson['chunkSize'];
        // var encryptedFile = _downloadFileFromStorj(storjUrl);
        // var encryptionService = _atClient.encryptionService!;
        // var decryptedFile = await encryptionService.decryptFileInChunks(
        //     encryptedFile, fileDecryptionKey, chunkSize);
        // decryptedFile.copySync(downloadPath + Platform.pathSeparator + );
      }
    });
  }

  File _downloadFileFromStorj(storjUrl) {
    return File("/home/Users/murali/hello.txt");
  }
}
