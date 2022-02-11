import 'package:auto_size_text/auto_size_text.dart';


import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:iot_reciever/models/iot_model.dart';

import 'package:iot_reciever/widgets/Gaugewidget.dart';

// * Once the onboarding process is completed you will be taken to this screen
class HomeScreen extends StatelessWidget {
  final ioT = IoT(sensorName: '@ZARIOT', heartRate: '3', bloodOxygen: '90', time: 'Todays Time');
   static const String id = '/home';
   HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // * Getting the AtClientManager instance to use below
    AtClientManager atClientManager = AtClientManager.getInstance();

    return Scaffold(
            appBar: AppBar(
        title: AutoSizeText(
          ioT.sensorName +  '    ' + ioT.time!,
          minFontSize: 5,),

      ),
      body: 
      Container(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(1),
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: GaugeWidget(
                measurement: 'Heart Rate',
                units: '',
                ioT: ioT,
                value: 'heartRate',
                decimalPlaces: 3,
                bottomRange: 0,
                topRange: 200,
                lowSector: 50,
                medSector: 130,
                highSector: 20,
                lowColor: Colors.red,
                medColor: Colors.green,
                highColor: Colors.red,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: GaugeWidget(
                measurement: 'O2',
                units: '%',
                ioT: ioT,
                value: 'bloodOxygen',
                decimalPlaces: 3,
                bottomRange: 90,
                topRange: 100,
                lowSector: 0.5,
                medSector: 9.5,
                highSector: 0,
                lowColor: Colors.red,
                medColor: Colors.green,
                highColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
