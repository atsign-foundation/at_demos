import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:at_client/at_client.dart';

class FileReceiver {
  final AtClient _atClient;

  FileReceiver(this._atClient);

  Future<void> receiveFile(String downloadPath) async {
    _atClient.notificationService
        .subscribe()
        .listen((AtNotification atNotification) async {
      if (atNotification.id != '-1') {
        var fileName;
        try {
          print('notification Received: ${atNotification.toString()}');
          var key = atNotification.key;
          var atValue = await _atClient.get(AtKey.fromString(key));
          print(atValue.toString());
          var valueJson = jsonDecode(atValue.value);
          var storjUrl = valueJson['fileUrl'];
          fileName = valueJson['fileName'];
          await downloadFileWithProgress(
              storjUrl, downloadPath, fileName, valueJson);
        } on Exception catch (e, trace) {
          print(e);
          print(trace);
        } on Error catch (e, trace) {
          print(e);
          print(trace);
        }
      }
    });
  }

  Future<void> _decryptFile(
      String downloadPath, String fileName, dynamic valueJson) async {
    try {
      var startTime = DateTime.now();
      var encryptionService = _atClient.encryptionService!;
      var encryptedFile =
          File('$downloadPath${Platform.pathSeparator}encrypted_$fileName');
      await encryptionService.decryptFileInChunks(
          encryptedFile, valueJson['fileEncryptionKey'], valueJson['chunkSize'],
          ivBase64: valueJson['iv']);
      var endTime = DateTime.now();
      print(
          'Time taken to decrypt file: ${endTime.difference(startTime).inSeconds}');
      var decryptedFile = File(
          "$downloadPath${Platform.pathSeparator}decrypted_encrypted_$fileName");
      if (decryptedFile.existsSync()) {
        decryptedFile
            .renameSync(downloadPath + Platform.pathSeparator + fileName);
      } else {
        throw Exception('could not decrypt downloaded file');
      }
    } on Exception catch (e, trace) {
      print(e);
      print(trace);
    } on Error catch (e, trace) {
      print(e);
      print(trace);
    } finally {
      var encryptedFile =
          File("$downloadPath${Platform.pathSeparator}encrypted_$fileName");
      if (encryptedFile.existsSync()) {
        encryptedFile.deleteSync();
      }
    }
  }

  Future<void> downloadFileWithProgress(String fileUrl, String downloadPath,
      String fileName, dynamic valueJson) async {
    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse('$fileUrl?download=1'));
    var response = httpClient.send(request);

    List<List<int>> chunks = [];
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        if (r.contentLength == null) {
          print('content length is null.');
          return;
        }
        // Display percentage of completion
        var percentage = downloaded / r.contentLength! * 100;
        int roundedPercent = percentage.round();
        updateProgress(roundedPercent);

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        // print('downloadPercentage: ${downloaded / r.contentLength! * 100}');

        // Save the file
        File file =
            File('$downloadPath${Platform.pathSeparator}encrypted_$fileName');
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        await _decryptFile(downloadPath, fileName, valueJson);
      });
    });
  }

  void updateProgress(int progress) {
    // Move cursor to the beginning of the line
    stdout.write('\r');

    // Print the progress in percentage
    stdout.write('Download progress: $progress%');
    stdout.flush();
  }
}
