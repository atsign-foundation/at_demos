import 'dart:async';
import 'dart:io';
import 'package:at_utils/at_utils.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart';

final client = MqttServerClient('localhost', '');
final AtSignLogger logger = AtSignLogger('iotListen');


Future<void> iotListen(AtClient atClient, String atsign, String toAtsign) async {
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
    logger.severe('client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    logger.severe('socket exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    logger.info('Mosquitto client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    logger.severe('ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  /// Let's get the atClient connection authorized before we go any further
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

  logger.info('calling atClient.put for HeartRate to ensure AtClient connection goes through authorization exchange');
  await atClient.put(key, '42.0');
  logger.info('Initial put complete, AtClient connection should now be authorized');

  /// Ok, lets try a subscription
  logger.info('Subscribing to the mqtt/mwc_hr topic');
  const topic = 'mqtt/mwc_hr'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce);

  logger.info('Subscribing to the mqtt/mwc_o2 topic');
  const topicTwo = 'mqtt/mwc_o2'; // Not a wildcard topic
  client.subscribe(topicTwo, MqttQos.atMostOnce);

  int putCounterHR = 0;
  int putCounterO2 = 0;

  // NOTE When this listenHandler function is called, the caller is not using await
  // i.e. this function can (and will) be called even if previous calls haven't yet completed
  // TODO If we encounter any more problems because of this, the solution is to have this
  //  listen handler just add the message to a local Queue, and have another function here
  //  which is reading from that Queue and doing the actual work
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    if (c[0].topic == "mqtt/mwc_hr") {
      logger.info('Heart Rate: ' + pt);
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

      int thisHRPutNo = ++putCounterHR;
      logger.info('calling atClient.put for HeartRate #$thisHRPutNo');
      await atClient.put(key, pt);
      logger.info('atClient.put #$thisHRPutNo complete');
    }

    if (c[0].topic == "mqtt/mwc_o2") {
      logger.info('Blood Oxygen: ' + pt);
      var metaData = Metadata()
        ..isPublic = false
        ..isEncrypted = true
        ..namespaceAware = true
        ..ttl = 100000;

      var key = AtKey()
        ..key = 'mwc_o2'
        ..sharedBy = atsign
        ..sharedWith = toAtsign
        ..metadata = metaData;

      int thisO2PutNo = ++putCounterO2;
      logger.info('calling atClient.put for O2 #$thisO2PutNo');
      await atClient.put(key, pt);
      logger.info('atClient.put #$thisO2PutNo complete');
    }
  });
}

/// The subscribed callback
void onSubscribed(String topic) {
  logger.info('Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  logger.info('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
    logger.info('OnDisconnected callback is solicited, this is correct');
  } else {
    logger.severe('OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
}

/// The successful connect callback
void onConnected() {
  print('INFO::OnConnected client callback - Client connection was successful');
}
