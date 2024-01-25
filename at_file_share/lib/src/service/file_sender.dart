import 'dart:convert';
import 'dart:io';

import 'package:at_client/at_client.dart';
import 'package:at_chops/at_chops.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
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
    var storJShareUrl = await _uploadToStorJ(encryptedFile,
        _atClient.getCurrentAtSign()!, basename(fileToSend.path));
    // var fileTransferObject = FileTransferObject(
    //     'test_transfer',
    //     fileEncryptionKey,
    //     storJShareUrl,
    //     basename(fileToSend.path),
    //     params.receiverAtSign,
    //     params.chunkSize);
    // //$TODO replace test_transfer with key name required for demo
    // var atKey = AtKey()
    //   ..key = 'test_transfer'
    //   ..sharedWith = params.receiverAtSign
    //   ..metadata = Metadata()
    //   ..metadata.ttr = -1;
    // var notificationResult = await _atClient.notificationService.notify(
    //   NotificationParams.forUpdate(
    //     atKey,
    //     value: jsonEncode(fileTransferObject.toJson()),
    //   ),
    // );
    // print('file share send notification: $notificationResult');
  }

  Future<String?> _uploadToStorJ(
      File encryptedFile, String atSign, String fileName) async {
    try {
      var storjUrl = await _getStorjUrl(atSign, fileName);
      print('storjUrl: $storjUrl');
      var res = await http.post(Uri.parse(storjUrl), headers: {
        "Content-Length": "0",
      });

      var putUri = Uri.parse(res.body);
      final streamedRequest = http.StreamedRequest('PUT', putUri);

      var imageLength = await encryptedFile.length();
      streamedRequest.contentLength = imageLength;

      encryptedFile.openRead().listen((chunk) {
        streamedRequest.sink.add(chunk);
      }, onDone: () {
        streamedRequest.sink.close();
      });

      http.StreamedResponse response = await streamedRequest.send();
      print('http response: $response');

      var shareableLink = await http.get(Uri.parse(storjUrl));
      if (shareableLink.statusCode == 200) {
        print('sharable line: $shareableLink');
        return shareableLink.body;
      } else {
        print('status code: ${shareableLink.statusCode}');
      }
    } on Exception catch (e, trace) {
      print(trace);
    } on Error catch (e, trace) {
      print(trace);
    }
  }

  Future<String> _getStorjUrl(String atSign, String fileName) async {
    var buzzKey = Platform.environment['ATBUZZKEY'];
    var nonce = "test_nonce"; //TODO - replace with impl
    var signedNonce = "test_signed_nonce"; //TODO - replace with impl
    String url =
        "https://tokengateway-bg7d74s2.uc.gateway.dev/gettoken?key=$buzzKey&atsign=$atSign&nonce=$nonce&signednonce=$signedNonce&filename=$fileName";
    return url;
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
