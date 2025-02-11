import 'dart:async';
import 'dart:isolate';

import 'package:programmable_policy/src/app/app.dart' as app;
import 'package:programmable_policy/src/service/service.dart';

Future<void> main() async {
  await spawnService(app.serviceHandler);
  app.run();
}

Future<void> spawnService(FutureOr<void> Function(ReceivePort, SendPort) handler) async {
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
    await Isolate.spawn((sendPort) {
      final receivePort = ReceivePort();
      sendPort.send(receivePort.sendPort);
      serviceMain(receivePort, sendPort);
    }, (initPort.sendPort));
  } on Object {
    initPort.close();
    rethrow;
  }

  final (ReceivePort receivePort, SendPort sendPort) = await connection.future;
  handler(receivePort, sendPort);
}
