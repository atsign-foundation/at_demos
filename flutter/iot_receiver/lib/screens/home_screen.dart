import 'dart:async';
import 'dart:io';
import 'package:at_utils/at_logger.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_receiver/models/iot_model.dart';
import 'package:iot_receiver/screens/devices_screen.dart';
import 'package:iot_receiver/screens/receivers_screen.dart';
import 'package:iot_receiver/services/hro2_data_service.dart';
import 'package:iot_receiver/widgets/gauge_widget.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

final AtSignLogger _logger = AtSignLogger('HomeScreen');

// * Once the onboarding process is completed you will be taken to this screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.ioT}) : super(key: key);
  static const String id = '/home_screen';
  final IoT ioT;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IoT readings = IoT(
      sensorName: '❤️        Atsign / ZARIOT        ❤️',
      heartRate: '0',
      bloodOxygen: '0',
      heartTime: DateTime.now().toString(),
      oxygenTime: DateTime.now().toString());
  Timer? timer;

  @override
  void initState() {
    super.initState();
    AtClientManager atClientManager = AtClientManager.getInstance();
    String? currentAtsign;
    AtClient atClient;
    atClient = atClientManager.atClient;
    currentAtsign = atClient.getCurrentAtSign();
    readings.currentAtsign = currentAtsign!;
    var notificationService = atClientManager.notificationService;
    atClientManager.syncService.sync(onDone: () {
      _logger.info('sync complete');
    });
    notificationService
        .subscribe(regex: '$currentAtsign:[O2|HR]', shouldDecrypt: true)
        .listen((notification) {
      _logger.info(
          'notification subscription handler got notification with key ${notification.toJson()}');
      if (mounted) {
        getAtsignData(context, notification);
      }
    });
    // reset dials if no data comes in checkExpiry(int Seconds)
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => checkExpiry(3));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    //AtClientManager atClientManager = AtClientManager.getInstance();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // var mediaQuery = MediaQuery.of(context);
    // var _width = mediaQuery.size.width * mediaQuery.devicePixelRatio;
    // var _height = mediaQuery.size.height * mediaQuery.devicePixelRatio;

    int gridRows = 1;
    if (width > height) {
      gridRows = 2;
    } else {
      gridRows = 1;
    }
    return Scaffold(
      appBar: NewGradientAppBar(
        title: AutoSizeText(
          readings.currentAtsign,
          minFontSize: 5,
          maxFontSize: 50,
        ),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 173, 83, 78),
          Color.fromARGB(255, 108, 169, 197)
        ]),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(255, 108, 169, 197),
            //padding: const EdgeInsets.symmetric(horizontal: 10),
            icon: const Icon(
              Icons.menu,
              size: 20,
            ),
            onSelected: (String result) {
              switch (result) {
                case 'CLOSE':
                  exit(0);
                case 'RECEIVERS':
                  Navigator.of(context).pushNamed(ReceiversScreen.id);
                  break;
                case 'DEVICES':
                  Navigator.of(context).pushNamed(DevicesScreen.id);
                  break;
                case 'RESET':
                  HrO2DataService().deleteAllData();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                height: 20,
                value: 'CLOSE',
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
              const PopupMenuItem<String>(
                height: 20,
                value: 'RECEIVERS',
                child: Text(
                  'RECEIVERS',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
              const PopupMenuItem<String>(
                height: 20,
                value: 'DEVICES',
                child: Text(
                  'DEVICES',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
              const PopupMenuItem<String>(
                height: 20,
                value: 'RESET',
                child: Text(
                  'RESET',
                  style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 5,
                      backgroundColor: Color.fromARGB(255, 108, 169, 197),
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: backgroundGradient(gridRows),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Table(
                children: [
                  if (gridRows == 1)
                    TableRow(children: [
                      SizedBox(
                        height: height / 16,
                      )
                    ]),
                  if (gridRows == 1)
                    TableRow(
                      children: [
                        if (double.parse(readings.heartRate.toString()) == 0)
                          GaugeWidget(
                            measurement: 'Heart Rate',
                            units: 'BPM',
                            ioT: readings,
                            value: 'heartRate',
                            decimalPlaces: 0,
                            bottomRange: 0,
                            topRange: 200,
                            lowSector: 50,
                            medSector: 130,
                            highSector: 20,
                            lowColor: const Color.fromARGB(30, 30, 30, 30),
                            medColor: const Color.fromARGB(50, 50, 50, 50),
                            highColor: const Color.fromARGB(30, 30, 30, 30),
                          ),
                        if (double.parse(readings.heartRate.toString()) != 0)
                          GaugeWidget(
                            measurement: 'Heart Rate',
                            units: 'BPM',
                            ioT: readings,
                            value: 'heartRate',
                            decimalPlaces: 0,
                            bottomRange: 0,
                            topRange: 200,
                            lowSector: 50,
                            medSector: 130,
                            highSector: 20,
                            lowColor: const Color.fromARGB(255, 161, 52, 44),
                            medColor: const Color.fromARGB(255, 75, 145, 78),
                            highColor: const Color.fromARGB(255, 161, 52, 44),
                          ),
                      ],
                    ),
                  if (gridRows == 1)
                    TableRow(children: [
                      if (double.parse(readings.bloodOxygen.toString()) == 0)
                        GaugeWidget(
                          measurement: 'Oxygen Saturation',
                          units: 'SpO2%',
                          ioT: readings,
                          value: 'bloodOxygen',
                          decimalPlaces: 1,
                          bottomRange: 90,
                          topRange: 100,
                          lowSector: 0.5,
                          medSector: 9.5,
                          highSector: 0,
                          lowColor: const Color.fromARGB(30, 30, 30, 30),
                          medColor: const Color.fromARGB(50, 50, 50, 50),
                          highColor: const Color.fromARGB(30, 30, 30, 30),
                        ),
                      if (double.parse(readings.bloodOxygen.toString()) != 0)
                        GaugeWidget(
                          measurement: 'Oxygen Saturation',
                          units: 'SpO2%',
                          ioT: readings,
                          value: 'bloodOxygen',
                          decimalPlaces: 1,
                          bottomRange: 90,
                          topRange: 100,
                          lowSector: 0.5,
                          medSector: 9.5,
                          highSector: 0,
                          lowColor: const Color.fromARGB(255, 161, 52, 44),
                          medColor: const Color.fromARGB(255, 75, 145, 78),
                          highColor: const Color.fromARGB(255, 161, 52, 44),
                        ),
                    ]),
                  // if (_gridRows == 1)
                  //   TableRow(children: [
                  //     SizedBox(
                  //       height: _height,
                  //     )
                  //   ]),
                  if (gridRows == 2)
                    TableRow(children: [
                      if (double.parse(readings.heartRate.toString()) == 0)
                        GaugeWidget(
                          measurement: 'Heart Rate',
                          units: 'BPM',
                          ioT: readings,
                          value: 'heartRate',
                          decimalPlaces: 0,
                          bottomRange: 0,
                          topRange: 200,
                          lowSector: 50,
                          medSector: 130,
                          highSector: 20,
                          lowColor: const Color.fromARGB(30, 30, 30, 30),
                          medColor: const Color.fromARGB(50, 50, 50, 50),
                          highColor: const Color.fromARGB(30, 30, 30, 30),
                        ),
                      if (double.parse(readings.heartRate.toString()) != 0)
                        GaugeWidget(
                          measurement: 'Heart Rate',
                          units: 'BPM',
                          ioT: readings,
                          value: 'heartRate',
                          decimalPlaces: 0,
                          bottomRange: 0,
                          topRange: 200,
                          lowSector: 50,
                          medSector: 130,
                          highSector: 20,
                          lowColor: const Color.fromARGB(255, 161, 52, 44),
                          medColor: const Color.fromARGB(255, 75, 145, 78),
                          highColor: const Color.fromARGB(255, 161, 52, 44),
                        ),
                      if (double.parse(readings.bloodOxygen.toString()) == 0)
                        GaugeWidget(
                          measurement: 'Oxygen Saturation',
                          units: 'SpO2%',
                          ioT: readings,
                          value: 'bloodOxygen',
                          decimalPlaces: 1,
                          bottomRange: 90,
                          topRange: 100,
                          lowSector: 0.5,
                          medSector: 9.5,
                          highSector: 0,
                          lowColor: const Color.fromARGB(30, 30, 30, 30),
                          medColor: const Color.fromARGB(50, 50, 50, 50),
                          highColor: const Color.fromARGB(30, 30, 30, 30),
                        ),
                      if (double.parse(readings.bloodOxygen.toString()) != 0)
                        GaugeWidget(
                          measurement: 'Oxygen Saturation',
                          units: 'SpO2%',
                          ioT: readings,
                          value: 'bloodOxygen',
                          decimalPlaces: 1,
                          bottomRange: 90,
                          topRange: 100,
                          lowSector: 0.5,
                          medSector: 9.5,
                          highSector: 0,
                          lowColor: const Color.fromARGB(255, 161, 52, 44),
                          medColor: const Color.fromARGB(255, 75, 145, 78),
                          highColor: const Color.fromARGB(255, 161, 52, 44),
                        ),
                    ]),
                  // if (_gridRows == 2)
                  //   TableRow(children: [
                  //     SizedBox(
                  //       height: _height,
                  //       width: _width,
                  //     ),
                  //     SizedBox(
                  //       height: _height,
                  //       width: _width,
                  //     )
                  //   ]),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      readings.sensorName,
                      style: const TextStyle(fontSize: 100),
                      textAlign: TextAlign.center,
                      maxFontSize: 50,
                      minFontSize: 4,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              //Some padding for desktops

              SizedBox(
                height: height / 8,
                width: width,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration backgroundGradient(int gridRows) {
    return BoxDecoration(
      color: Colors.white70,
      gradient: gridRows > 1
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 240, 181, 178),
                Color.fromARGB(255, 171, 200, 224)
              ],
            )
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 240, 181, 178),
                Color.fromARGB(255, 171, 200, 224)
              ],
            ),
      image: const DecorationImage(
        opacity: .15,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        image: AssetImage(
          'assets/images/blood-pressure.png',
        ),
      ),
    );
  }

  void getAtsignData(BuildContext context, AtNotification notification) async {
    var notificationJson = notification.toJson();
    var notificationKey = notificationJson['key'];
    List keyAtsign = notificationKey.split(':');
    String sharedByAtsign = notificationJson['from'];
    String currentAtsign = notificationJson['to'];
    String shortName = "";
    if (keyAtsign.length > 3) {
      shortName = keyAtsign[3];
    }
    var value = keyAtsign[2];
    if (keyAtsign[1] == 'HR') {
      readings.heartRate = value;
      // Use this for created at source (reader)
      //readings.heartTime = reading.metadata?.createdAt?.toString();
      // Or this f client got the reading (safer for demos!)
      readings.heartTime = DateTime.now().toUtc().toString();
    }
    if (keyAtsign[1] == 'O2') {
      readings.bloodOxygen = value;
      // Use this for created at source (reader)
      // readings.oxygenTime = reading.metadata?.createdAt?.toString();
      //Or this f client got the reading (safer for demos!)
      readings.oxygenTime = DateTime.now().toUtc().toString();
    }
    // Use this for created at source (reader)
    //Or this f client got the reading (safer for demos!)
    var createdAt =
        DateTime.fromMillisecondsSinceEpoch(notificationJson['epochMillis']);
    var dateFormat = DateFormat("HH:mm.ss");
    String dateFormatted = dateFormat.format(createdAt);
    readings.sensorName =
        '❤️         $shortName|$sharedByAtsign|$dateFormatted         ❤️';
    if (mounted) {
      setState(() {});
    }
    _logger.info(
        'Yay $currentAtsign was just sent a $keyAtsign reading of $value ! From $sharedByAtsign');
  }

  void checkExpiry(int expireSeconds) {
    var heartExpire = DateTime.parse(readings.heartTime.toString());
    var oxygenExpire = DateTime.parse(readings.oxygenTime.toString());
    heartExpire = heartExpire.toUtc();
    oxygenExpire = oxygenExpire.toUtc();
    bool noO2 = false;
    bool noHR = false;
    var now = DateTime.now().toUtc();
    now = now.subtract(Duration(seconds: expireSeconds));
    if (now.isAfter(heartExpire)) {
      readings.heartRate = '0';
      noHR = true;
      if (mounted) {
        setState(() {});
      }
    }
    if (now.isAfter(oxygenExpire)) {
      noO2 = true;
      readings.bloodOxygen = '0';
      if (mounted) {
        setState(() {});
      }
    }
    if (noHR && noO2) {
      readings.sensorName = '❤️        Atsign / ZARIOT        ❤️';
      if (mounted) {
        setState(() {});
      }
    }
  }
}
