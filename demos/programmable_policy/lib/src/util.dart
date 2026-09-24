import 'dart:isolate' show SendPort;

void sendLogMessage(SendPort sendPort, String atSign, String message) {
  sendPort.send("logs:$atSign:$message");
}
