import 'dart:collection';
import 'dart:isolate';

void serviceMain(ReceivePort recvPort, SendPort sendPort) {
  Queue messageQueue();
  recvPort.listen((message) {});
}
