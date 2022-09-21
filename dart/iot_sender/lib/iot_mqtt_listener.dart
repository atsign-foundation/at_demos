import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:at_utils/at_utils.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:at_client/at_client.dart';
//import 'package:at_commons/at_commons.dart';
import 'package:iot_sender/models/send_hr02_receiver.dart';

final client = MqttServerClient('localhost', '');
final AtSignLogger logger = AtSignLogger('iotListen');

bool fakingO2SatValues = false;
Random random = Random();
int fakeO2IntMinValue = 950;
int fakeO2IntMaxValue = 995;
// fakeO2 value in int, convert to double by dividing by 10 when publishing
int currentFakeO2IntValue = random.nextInt(fakeO2IntMaxValue - fakeO2IntMinValue) + fakeO2IntMinValue;

int getNextFakeO2IntValue() {
  // get random int in range -5..+5
  // so the double value will have a change delta of -0.5 to +0.5
  int fakeO2Delta = random.nextInt(11) - 5;

  currentFakeO2IntValue += fakeO2Delta;
  if (currentFakeO2IntValue > fakeO2IntMaxValue) {
    currentFakeO2IntValue = fakeO2IntMaxValue;
  } else if (currentFakeO2IntValue < fakeO2IntMinValue) {
    currentFakeO2IntValue = fakeO2IntMinValue;
  }
  return currentFakeO2IntValue;
}

bool _sendHR = true;
bool _sendO2 = true;
int _putCounterHR = 0;
int _putCounterO2 = 0;

Future<void> iotListen(AtClientManager atClientManager, NotificationService notificationService, String fromAtsign,
    String ownerAtsign, String deviceName) async {
  client.logging(on: false);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;

  double lastHeartRateDoubleValue = 0.0;
  double lastO2SatDoubleValue = 0.0;

  AtClient atClient = atClientManager.atClient;

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

  logger.info('calling atClient.put for HeartRate to ensure AtClient connection goes through authorization exchange');

  logger.info('Initial put complete, AtClient connection should now be authorized');

  /// Ok, lets try a subscription
  logger.info('Subscribing to the mqtt/mwc_hr topic');
  const topic = 'mqtt/mwc_hr'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce);

  logger.info('Subscribing to the mqtt/mwc_o2 topic');
  const topicTwo = 'mqtt/mwc_o2'; // Not a wildcard topic
  client.subscribe(topicTwo, MqttQos.atMostOnce);

  logger.info('Subscribing to the mqtt/mwc_beat_hr_o2 topic');
  const combinedTopic = 'mqtt/mwc_beat_hr_o2'; // Not a wildcard topic
  client.subscribe(combinedTopic, MqttQos.atMostOnce);

  // NOTE When this listenHandler function is called, the caller is not using await
  // i.e. this function can (and will) be called even if previous calls haven't yet completed

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    List<SendHrO2Receiver> toAtsigns = await getReceivers(atClient, ownerAtsign, deviceName);


for (var receiver in toAtsigns) {      
    logger.info('Notification config: '+ receiver.toJson().toString());
          }
      

    if (toAtsigns.isNotEmpty) {
// pick up HR
      if (c[0].topic == "mqtt/mwc_hr") {
        double? heartRateDoubleValue = double.tryParse(pt);
        heartRateDoubleValue ??= lastHeartRateDoubleValue;
        lastHeartRateDoubleValue = heartRateDoubleValue;
        for (var receiver in toAtsigns) {
          if (receiver.sendHR) {
            await shareHeartRate(
                heartRateDoubleValue, fromAtsign, receiver.sendToAtsign, receiver.sendToShortname, notificationService);
          }

          if (fakingO2SatValues) {
            // get random int between 0 and 101, then subtract 50 to get a number in range -50..+50
            currentFakeO2IntValue = getNextFakeO2IntValue();
            double fakeO2DoubleValue = currentFakeO2IntValue / 10;
            await shareO2Sat(
                fakeO2DoubleValue, fromAtsign, receiver.sendToAtsign, receiver.sendToShortname, notificationService);
          }
        }
      }

//pick up O2
      if (c[0].topic == "mqtt/mwc_o2") {
        double? o2SatDoubleValue = double.tryParse(pt);
        o2SatDoubleValue ??= lastO2SatDoubleValue;
        lastO2SatDoubleValue = o2SatDoubleValue;
        for (var receiver in toAtsigns) {
          if (receiver.sendO2) {
            await shareO2Sat(
                o2SatDoubleValue, fromAtsign, receiver.sendToAtsign, receiver.sendToShortname, notificationService);
          }
        }
      }

// pick up both HR and O2
      if (c[0].topic == "mqtt/mwc_beat_hr_o2") {
        List<String> beatBpmSpo = ['false', '0', '0'];
        bool hrDetect = false;
        double bpm = 0;
        double spo = 0;
        try {
          beatBpmSpo = pt.split(",");
          hrDetect = beatBpmSpo[0].parseBool();
          bpm = double.parse(beatBpmSpo[1]);
          spo = double.parse(beatBpmSpo[2]);
        } catch (e) {
          logger.severe('Error in message sent to mqtt/mwc_beat_hr_o2 format HR,O2 and this was recieved: $pt');
        }
        if (hrDetect) {
          for (var receiver in toAtsigns) {
            if (receiver.sendHR) {
              await shareHeartRate(
                  bpm, fromAtsign, receiver.sendToAtsign, receiver.sendToShortname, notificationService);
            }
            if (receiver.sendO2) {
              await shareO2Sat(spo, fromAtsign, receiver.sendToAtsign, receiver.sendToShortname, notificationService);
            }
          }
        }
      }
    }
  });
}

Future<List<SendHrO2Receiver>> getReceivers(AtClient atClient, String ownerAtsign, String deviceName) async {
  String receiversString = '';

  var metaData = Metadata()
    ..isPublic = false
    ..isEncrypted = true
    ..namespaceAware = true;

  var key = AtKey()
    ..key = '$deviceName.config'
    ..namespace = atClient.getPreferences()!.namespace
    ..sharedBy = ownerAtsign
    ..metadata = metaData;

  try {
    AtValue atReceiversAtValue = await atClient.get(key);
    receiversString = atReceiversAtValue.value;
  } catch (e) {
    logger.severe(e.toString());
  }

  List<SendHrO2Receiver> toAtsigns = [];
  if (receiversString.isNotEmpty) {
    var senders = jsonDecode(receiversString);

    for (var i = 0; i < senders.length; i++) {
      toAtsigns.add(SendHrO2Receiver.fromJson(senders[i]));
    }
  }
  return toAtsigns;
}

Future<void> shareHeartRate(double heartRate, String atsign, String toAtsign, String sendToShortname,
    NotificationService notificationService) async {
  if (!_sendHR) {
    return;
  }

  String heartRateAsString = heartRate.toStringAsFixed(1);
  logger.info('Heart Rate: $heartRateAsString');

  int thisHRPutNo = ++_putCounterHR;
  logger.info('calling atClient.put for HeartRate #$thisHRPutNo');
  try {
    await notificationService.notify(
        NotificationParams.forText('HR:$heartRateAsString:$sendToShortname', toAtsign, shouldEncrypt: true),
        checkForFinalDeliveryStatus: false, onSuccess: (notification) {
      logger.info('SUCCESS:$notification');
    }, onError: (notification) {
      logger.info('ERROR:$notification');
    }, onSentToSecondary: (notification) {
      logger.info('SENT:$notification');
    }, waitForFinalDeliveryStatus: false);
  } catch (e) {
    logger.severe(e.toString());
  }
  logger.info('atClient.put #$thisHRPutNo complete');
}

Future<void> shareO2Sat(double o2Sat, String atsign, String toAtsign, String sendToShortname,
    NotificationService notificationService) async {
  if (!_sendO2) {
    return;
  }

  String o2SatAsString = o2Sat.toStringAsFixed(1);
  logger.info('Blood Oxygen: $o2SatAsString');

  try {
    await notificationService.notify(
        NotificationParams.forText(
          'O2:$o2SatAsString:$sendToShortname',
          toAtsign,
          shouldEncrypt: true,
        ),
        checkForFinalDeliveryStatus: false, onSuccess: (notification) {
      logger.info('SUCCESS:$notification');
    }, onError: (notification) {
      logger.info('ERROR:$notification');
    }, onSentToSecondary: (notification) {
      logger.info('SENT:$notification');
    }, waitForFinalDeliveryStatus: false);
  } catch (e) {
    logger.severe(e.toString());
  }

  int thisO2PutNo = ++_putCounterO2;
  logger.info('calling atClient.put for O2 #$thisO2PutNo');
  logger.info('atClient.put #$thisO2PutNo complete');
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
  logger.info('OnConnected client callback - Client connection was successful');
}

extension BoolParsing on String {
  bool parseBool() {
    if (toLowerCase().trimLeft().trimRight() == 'true') {
      return true;
    } else if (toLowerCase().trimLeft().trimRight() == 'false') {
      return false;
    }
    throw '"$this" can not be parsed to boolean.';
  }
}
