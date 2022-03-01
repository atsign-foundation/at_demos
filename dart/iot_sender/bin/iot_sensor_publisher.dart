import 'package:max30101/max30101.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:io';

import 'package:mqtt_client/mqtt_server_client.dart';

void main(List<String> arguments) async {
  void printUsage() {
    print('Usage: iot_sensor_publisher [mode]');
    print("    where <mode> is one of {hr|o2|hro2}");
    exit(0);
  }

  if (arguments.length > 1) {
    printUsage();
  }

  bool sendHR = true;
  bool sendO2 = true;

  if (arguments.isNotEmpty) {
    String mode = arguments[0].toLowerCase();
    switch(mode) {
      case 'hr':
        sendHR = true;
        break;
      case 'o2':
        sendO2 = true;
        break;
      case 'hro2':
        sendHR = true;
        sendO2 = true;
        break;
      default:
        printUsage();
    }
  }

  /// This sender integrates with the sensor and publishes on 'mwc_beat_hr_o2' topic
  /// Which in turn is subscribed to by (a) the python TFT driver (b) the iot_mqtt_listener

  /// The MAX30101 sensor driver
  printWithTimestamp("Starting Max30101 sampler");

  final publishingClient = MqttServerClient('localhost', 'max');
  try {
    await publishingClient.connect();
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    printWithTimestamp('client exception - $e');
    publishingClient.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    printWithTimestamp('socket exception - $e');
    publishingClient.disconnect();
  }

  /// Check we are connected
  if (publishingClient.connectionStatus!.state == MqttConnectionState.connected) {
    printWithTimestamp('Mosquitto publishing client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    printWithTimestamp('ERROR Mosquitto publishing client connection failed - disconnecting, status is ${publishingClient.connectionStatus}');
    publishingClient.disconnect();
    exit(-1);
  }

  const String publishTopic = 'mqtt/mwc_beat_hr_o2';

  void onBeat(bool beatDetected, double bpm, double sao2) {
    if (! sendHR) {
      bpm = 0.0;
    }
    if (! sendO2) {
      sao2 = 0.0;
    }

    printWithTimestamp("onBeat called with beatDetected:$beatDetected bpm:$bpm sao2:$sao2 : publishing to $publishTopic");
    String message = '${beatDetected.toString().toLowerCase()},${bpm.toStringAsFixed(1)},${sao2.toStringAsFixed(1)}';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    publishingClient.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);
    printWithTimestamp("onBeat published $message to $publishTopic");
  }

  MAX30101 max30101 = MAX30101(RealI2CWrapper(1), false, debug:false);
  max30101.runSampler(onBeat);
}
