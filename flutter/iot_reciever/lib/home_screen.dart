import 'package:auto_size_text/auto_size_text.dart';


import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:iot_reciever/models/iot_model.dart';

import 'widgets/Gaugewidget.dart';

// * Once the onboarding process is completed you will be taken to this screen
class HomeScreen extends StatelessWidget {
  final ioT = IoT(sensorName: '@ZARIOT', heartRate: 'heartRate', bloodOxygen: 'bloodOxygen');
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
                measurement: 'SWR',
                units: '',
                ioT: ioT,
                value: 'heartRate',
                decimalPlaces: 3,
                bottomRange: 1,
                topRange: 5,
                lowSector: 1.3,
                medSector: 1.7,
                highSector: 1.0,
                lowColor: Colors.lightGreen,
                medColor: Colors.green,
                highColor: Colors.red,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: GaugeWidget(
                measurement: 'Modulation',
                units: '%',
                ioT: ioT,
                value: 'bloodOxygen',
                decimalPlaces: 3,
                bottomRange: 0,
                topRange: 110,
                lowSector: 40.0,
                medSector: 65.0,
                highSector: 5.0,
                lowColor: Colors.red,
                medColor: Colors.lightGreen,
                highColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
