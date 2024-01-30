import 'dart:io';
import 'dart:convert';
import 'package:at_client/at_client.dart';
import 'package:at_chops/at_chops.dart';
import 'package:path/path.dart';

import 'package:at_file_share/src/file_send_params.dart';

class FileSender {
  final AtClient atClient;

  FileSender(this.atClient);

  Future<void> sendFile(FileSendParams params) async {
    var fileToSend = File(params.filePath);
    if (!fileToSend.existsSync()) {
      throw Exception("File doesn't exits in path ${params.filePath}");
    }
    stderr.writeln('Generating AES key and IV');
    var fileEncryptionKey =
        AtChopsUtil.generateSymmetricKey(EncryptionKeyType.aes256).key;
    var encryptionService = atClient.encryptionService!;
    String iv = EncryptionUtil.generateIV();

    stderr.writeln('Encrypting file');
    var encryptedFile = await encryptionService.encryptFileInChunks(
        fileToSend, fileEncryptionKey, params.chunkSize,
        ivBase64: iv);

    stderr.writeln('Uploading to Storj');
    var storJShareUrl =
        await _uploadToStorJ(encryptedFile, basename(params.filePath), params);
    stderr.writeln('storJShareUrl: $storJShareUrl');
    if (storJShareUrl == null) {
      throw Exception('upload to storJ failed');
    }
    var fileTransferObject = FileTransferObject(
        'acme_transfer',
        fileEncryptionKey,
        storJShareUrl,
        basename(fileToSend.path),
        params.receiverAtSign,
        params.chunkSize,
        iv);

    var atKey = AtKey()
          ..key = '${DateTime.now().millisecondsSinceEpoch}'
              '.files'
              '.${atClient.getPreferences()!.namespace!}'
          ..sharedBy = atClient.getCurrentAtSign()
          ..sharedWith = params.receiverAtSign
          ..metadata.namespaceAware =
              true // we've included the namespace already
        ;

    stderr.writeln('Sending notification with key $atKey');
    await atClient.notificationService.notify(
      NotificationParams.forUpdate(
        atKey,
        value: jsonEncode(fileTransferObject.toJson()),
      ),
      waitForFinalDeliveryStatus: false,
      checkForFinalDeliveryStatus: false,
    );
  }

  Future<String?> _uploadToStorJ(
      File encryptedFile, String fileName, FileSendParams sendParams) async {
    try {
      String command = 'uplink';
      List<String> arguments = [
        'cp',
        encryptedFile.path,
        'sj://${sendParams.bucketName}'
      ];

      // Create a ProcessResult object by running the command
      var startTime = DateTime.now();
      ProcessResult result = await Process.run(command, arguments);
      var endTime = DateTime.now();
      stderr.writeln('upload time taken in seconds:'
          ' ${endTime.difference(startTime).inSeconds}');
      // Print the output of the command
      stderr.writeln('upload Exit code: ${result.exitCode}');
      stderr.writeln('upload Stdout: ${result.stdout}');
      arguments = [
        'share',
        '--url',
        '--register',
        'sj://demo-bucket/${basename(encryptedFile.path)}',
        '--not-after=24h'
      ];
      result = await Process.run(command, arguments);
      // Print the output of the command
      stderr.writeln('share Exit code: ${result.exitCode}');
      stderr.writeln('share stdout: ${result.stdout}');
      var resultString = result.stdout.toString();
      var shareUrl =
          resultString.substring(resultString.indexOf('URL       :') + 12);
      stderr.writeln('shareUrl: $shareUrl');
      return shareUrl.trim();
    } on Exception catch (e, trace) {
      stderr.writeln('inside exception');
      stderr.writeln(e.toString());
      stderr.writeln(trace);
    } on Error catch (e, trace) {
      stderr.writeln('inside error');
      stderr.writeln(e.toString());
      stderr.writeln(trace);
    } finally {
      File(encryptedFile.path).deleteSync();
    }
    return null;
  }
}

// add any additional params if required
class FileTransferObject {
  final String transferId;

  //final List<FileStatus> fileStatus;
  final String fileEncryptionKey;
  final String fileUrl;
  final String fileName;
  final String sharedWith;
  String? notes;
  final String iv;
  DateTime? date;
  int chunkSize;

  FileTransferObject(this.transferId, this.fileEncryptionKey, this.fileUrl,
      this.fileName, this.sharedWith, this.chunkSize, this.iv,
      {this.date}) {
    date ??= DateTime.now().toUtc();
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map toJson() {
    var map = {};
    map['transferId'] = transferId;
    map['fileEncryptionKey'] = fileEncryptionKey;
    map['fileUrl'] = fileUrl;
    map['fileName'] = fileName;
    map['sharedWith'] = sharedWith;
    map['chunkSize'] = chunkSize;
    map['iv'] = iv;
    map['date'] = date!.toUtc().toString();
    map['notes'] = notes;
    return map;
  }
}
