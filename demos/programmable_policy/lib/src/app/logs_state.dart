import 'dart:async';

class LogsState {
  // max size of logs list
  static const int maxSize = 10000;

  // how many items to remove when max is reached
  static const int removeAmount = 250;

  final Stream<String> events;

  /// logs: List<(String atSign, String message)>
  final List<(String, String)> logs = [];

  final List<String> atSigns = [];

  // Stream controller and stream to push updates to the Flutter UI
  final StreamController<int> _atSignsController = StreamController();
  Stream<int> get atSignsSize => _atSignsController.stream;

  List<String> filtered(String atSign) {
    return logs.where((e) => e.$1 == atSign).map((e) => e.$2).toList();
  }

  LogsState(this.events) {
    events.listen((event) {
      var line = decodeLogMessage(event);
      if (line != null) {
        if (logs.length >= maxSize) {
          logs.removeRange(0, removeAmount);
        }
        logs.add(line);
        if (!atSigns.contains(line.$1)) {
          atSigns.add(line.$1);
          _atSignsController.add(atSigns.length);
        }
      }
    });
  }

  /// returns (String atSign, String message)?
  (String, String)? decodeLogMessage(String event) {
    if (!event.startsWith("logs")) {
      return null;
    }
    try {
      var parts = event.split(":");
      var atsign = parts[1];
      var message = parts.getRange(2, parts.length).join(":");
      return (atsign, message);
    } catch (_) {
      return null;
    }
  }
}
