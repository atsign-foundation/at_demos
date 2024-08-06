import 'dart:convert';

class AtDataShareRequest {
  late String requestId;
  late Map<String, dynamic> jsonSchema;
  late String requestedByAtSign;
  late String requestedToAtSign;
  Via via = Via.notification;

  @override
  String toString() {
    return 'datasharerequest_${jsonEncode({
          'requestId': requestId,
          'requestedByAtSign': requestedByAtSign.replaceAll('@', ''),
          'requestedToAtSign': requestedToAtSign.replaceAll('@', ''),
          'via': Via.notification.name,
          'jsonSchema': jsonEncode(jsonSchema)
        })}';
  }

  static AtDataShareRequest fromJson(
      Map<String, dynamic> atDataShareRequestMap) {
    AtDataShareRequest atDataShareRequest = AtDataShareRequest()
      ..requestId = atDataShareRequestMap['requestId']!
      ..jsonSchema = jsonDecode(atDataShareRequestMap['jsonSchema']!)
      ..requestedByAtSign = atDataShareRequestMap['requestedByAtSign']!
      ..requestedToAtSign = atDataShareRequestMap['requestedToAtSign'];
    return atDataShareRequest;
  }
}

class AtDataShareResponse {
  late String responseId;
  late Map<String, dynamic> jsonSchema;
  late String senderAtSign;
  Via via = Via.notification;

  @override
  String toString() {
    return 'datashareresponse_${jsonEncode({
          'responseId': responseId,
          'senderAtSign': senderAtSign.replaceAll('@', ''),
          'via': Via.notification.name,
          'jsonSchema': jsonEncode(jsonSchema)
        })}';
  }

  static AtDataShareResponse fromJson(
      Map<String, dynamic> atDataShareResponseMap) {
    AtDataShareResponse atDataShareResponse = AtDataShareResponse()
      ..responseId = atDataShareResponseMap['responseId']!
      ..jsonSchema = jsonDecode(atDataShareResponseMap['jsonSchema']!)
      ..senderAtSign = atDataShareResponseMap['senderAtSign']!;
    return atDataShareResponse;
  }

  Map toJson() {
    Map map = {};
    map['responseId'] = responseId;
    map['jsonSchema'] = jsonEncode(jsonSchema);
    map['senderAtSign'] = senderAtSign;
    map['via'] = Via.notification.name;

    return map;
  }
}

enum Via { key, notification }
