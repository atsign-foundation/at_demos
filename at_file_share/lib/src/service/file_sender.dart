import 'dart:io';
import 'dart:convert';
import 'package:at_client/at_client.dart';
import 'package:at_chops/at_chops.dart';
import 'package:path/path.dart';

import 'package:at_file_share/src/file_send_params.dart';

class FileSender {
  final AtClient _atClient;
  FileSender(this._atClient);
  Future<void> sendFile(FileSendParams params) async {
    var fileToSend = File(params.filePath);
    if (!fileToSend.existsSync()) {
      throw Exception("File doesn't exits in path ${params.filePath}");
    }
    var fileEncryptionKey =
        AtChopsUtil.generateSymmetricKey(EncryptionKeyType.aes256).key;
    var encryptionService = _atClient.encryptionService!;
    var encryptedFile = await encryptionService.encryptFileInChunks(
        fileToSend, fileEncryptionKey, params.chunkSize);
    var storJShareUrl =
        await _uploadToStorJ(encryptedFile, basename(params.filePath), params);
    print('storJShareUrl: $storJShareUrl');
    if (storJShareUrl == null) {
      throw Exception('upload to storJ failed');
    }
    var fileTransferObject = FileTransferObject(
        'test_transfer',
        fileEncryptionKey,
        storJShareUrl,
        basename(fileToSend.path),
        params.receiverAtSign,
        params.chunkSize);
    //$TODO replace test_transfer with key name required for demo
    var atKey = AtKey()
      ..key = 'test_transfer'
      ..sharedWith = params.receiverAtSign
      ..metadata = Metadata()
      ..metadata.ttr = -1;
    var notificationResult = await _atClient.notificationService.notify(
      NotificationParams.forUpdate(
        atKey,
        value: jsonEncode(fileTransferObject.toJson()),
      ),
    );
    print('file share send notification: $notificationResult');
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
      print(
          'upload time taken in seconds: ${endTime.difference(startTime).inSeconds}');
      // Print the output of the command
      print('upload Exit code: ${result.exitCode}');
      print('upload Stdout: ${result.stdout}');
      arguments = [
        'share',
        '--url',
        '--register',
        'sj://demo-bucket/${basename(encryptedFile.path)}',
        '--not-after=24h'
      ];
      result = await Process.run(command, arguments);
      // Print the output of the command
      print('share Exit code: ${result.exitCode}');
      print('share stdout: ${result.stdout}');
      var resultString = result.stdout.toString();
      var shareUrl =
          resultString.substring(resultString.indexOf('URL       :') + 12);
      print('shareUrl: $shareUrl');
      return shareUrl.trim();
    } on Exception catch (e, trace) {
      print('inside exception');
      print(e.toString());
      print(trace);
    } on Error catch (e, trace) {
      print('inside error');
      print(e.toString());
      print(trace);
    } finally {
      File(encryptedFile.path).deleteSync();
    }
    return null;
  }
  // Future<String> getInitialUrl(String atsign, String fileName,String privateKey) async {
  //   var atBuzzKey = Platform.environment['ATBUZZKEY'];
  //   print('$atBuzzKey: $atBuzzKey');
  //   var nonce = await getnonce();
  //   var signedNonce = await signNonce(nonce, privateKey);
  //   String url =
  //       "https://tokengateway-bg7d74s2.uc.gateway.dev/gettoken?key=$atBuzzKey&atsign=$atsign&nonce=$nonce&signednonce=$signedNonce&filename=$fileName";
  //   return url;
  // }
  //
  // Future<String> getnonce() async {
  //   var atBuzzKey = Platform.environment['ATBUZZKEY'];
  //   String url = "https://noncegateway-bg7d74s2.uc.gateway.dev/getnonce?key=$atBuzzKey";
  //   var res = await http.get(Uri.parse(url));
  //   return res.body;
  // }
  //
  // Future<String> signNonce(String nonce,String atSignPrivateKey) async {
  //   var signature = RSAPrivateKey.fromString(atSignPrivateKey).createSHA256Signature(utf8.encode(nonce));
  //   return base64UrlEncode(signature);
  // }
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
  //bool? sharedStatus;
  DateTime? date;
  int chunkSize;

  FileTransferObject(this.transferId, this.fileEncryptionKey, this.fileUrl,
      this.fileName, this.sharedWith, this.chunkSize,
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
    //map['sharedStatus'] = sharedStatus;
    //map['fileStatus'] = fileStatus;
    map['date'] = date!.toUtc().toString();
    map['notes'] = notes;
    return map;
  }
}
