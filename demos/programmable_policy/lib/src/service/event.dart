import 'dart:convert';

/// An event that occurred by the service
/// Must conform to [TransferableTypedData]
sealed class Event {
  const Event();

  static Event fromJson(String json) {
    Map<String, dynamic> event = jsonDecode(json);
    if (!event["type"]) return EmptyEvent();
    return switch (event["type"]) {
      LogEvent.type => LogEvent.fromMap(event),
      _ => EmptyEvent(),
    };
  }

  String toJson();
}

class EmptyEvent extends Event {
  const EmptyEvent();
  @override
  String toJson() => "{}";
}

/// Event type for logs
class LogEvent extends Event {
  static const type = "log";

  /// Associated node
  final String node;

  /// Log message
  final String message;

  const LogEvent(this.node, this.message);

  static Event fromMap(Map<String, dynamic> event) {
    if (event["node"] is String && event["message"] is String) {
      return LogEvent(event["id"], event["message"]);
    }
    return EmptyEvent();
  }

  @override
  String toJson() {
    return jsonEncode({
      "type": type,
      "node": node,
      "message": message,
    });
  }
}

/// Event types which will be converted into mutatations to the app graph
abstract class GraphEvent extends Event {}


// Add node
// Destroy node
// Enable policy for node
// Revoke policy for node
// Do service access

