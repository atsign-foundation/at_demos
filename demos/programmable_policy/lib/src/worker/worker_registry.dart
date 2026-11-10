import 'dart:isolate';

import 'package:programmable_policy/src/policy/policy_main.dart';
import 'package:programmable_policy/src/simulation_driver/simulation_main.dart';

void _policy(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  policyMain(receivePort, sendPort);
}

void _simulation(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  simulationMain(receivePort, sendPort);
}

// Cannot use closures, because this gets called on the isolate
const Map<String, void Function(SendPort)> workerRegistry = {
  'policy': _policy,
  'simulation': _simulation,
};
