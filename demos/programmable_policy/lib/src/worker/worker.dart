import 'dart:async';
import 'dart:isolate';

import 'package:programmable_policy/src/worker/worker_registry.dart';

/// Spawns a worker isolate
/// [T] is the generic message type that the Worker sends and receives
/// Must conform to types that are valid to send over a [SendPort]
Future<Worker<T>> spawnWorker<T>(String worker) async {
  final initPort = RawReceivePort();
  final connection = Completer<(ReceivePort, SendPort)>.sync();
  initPort.handler = (initialMessage) {
    final commandPort = initialMessage as SendPort;
    connection.complete((
      ReceivePort.fromRawReceivePort(initPort),
      commandPort,
    ));
  };

  try {
    await Isolate.spawn(workerRegistry[worker]!, (initPort.sendPort));
  } on Object {
    initPort.close();
    rethrow;
  }

  final (ReceivePort receivePort, SendPort sendPort) = await connection.future;
  return Worker<T>(receivePort, sendPort);
}

class Worker<T> {
  final ReceivePort _receivePort;
  final SendPort _sendPort;

  // Stream of messages from isolate
  final StreamController _eventStream = StreamController<T>();

  Worker(this._receivePort, this._sendPort) {
    _receivePort.listen((data) {
      if (data is T) _eventStream.add(data);
    });
  }

  Stream<T> get events => _eventStream.stream as Stream<T>;
  void send(T command) {
    _sendPort.send(command);
  }
}
