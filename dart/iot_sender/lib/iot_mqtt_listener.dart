import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart';


final client = MqttServerClient('localhost', '');

Future<int> iotListen(AtClient atClient, String atsign, String toAtsign) async {
  client.logging(on: false);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('INFO::client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('INFO::socket exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('INFO::Mosquitto client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'INFO::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  /// Ok, lets try a subscription
  print('INFO::Subscribing to the mqtt/mwc_hr topic');
  const topic = 'mqtt/mwc_hr'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce);

  print('INFO::Subscribing to the mqtt/mwc_o2 topic');
  const topicTwo = 'mqtt/mwc_o2'; // Not a wildcard topic
  client.subscribe(topicTwo, MqttQos.atMostOnce);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);


    if (c[0].topic == "mqtt/mwc_hr")  {
      print('Heart Rate: ' + pt);
    var metaData = Metadata()
    ..isPublic = false
    ..isEncrypted = true
    ..namespaceAware = true
    ..ttl = 100000;

  var key = AtKey()
    ..key = 'mwc_hr'
    ..sharedBy = atsign
    ..sharedWith = toAtsign
    ..metadata = metaData;

  await atClient.put(key, pt);
    }

    if (c[0].topic == "mqtt/mwc_o2") {
      print('Blood Oxygen: ' + pt);
          var metaData = Metadata()
    ..isPublic = false
    ..isEncrypted = true
    ..namespaceAware = true
    ..ttl = 100000;

  var key = AtKey()
    ..key = 'mwc_o2'
    ..sharedBy = atsign
    ..sharedWith = '@colin'
    ..metadata = metaData;

  await atClient.put(key, pt);
    }
  });

  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('INFO::Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('INFO::OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('INFO::OnDisconnected callback is solicited, this is correct');
  } else {
    print(
        'INFO::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
}

/// The successful connect callback
void onConnected() {
  print('INFO::OnConnected client callback - Client connection was successful');
}
