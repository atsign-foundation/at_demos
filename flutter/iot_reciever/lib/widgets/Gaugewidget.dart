// ignore_for_file: unnecessary_this

import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter/material.dart';
import 'package:iot_reciever/models/iot_model.dart';

class GaugeWidget extends StatefulWidget {
  final IoT ioT;
  final String measurement;
  final String value;
  final int decimalPlaces;
  final String units;
  final double bottomRange;
  final double topRange;
  final Color lowColor;
  final Color medColor;
  final Color highColor;
  final double lowSector;
  final double medSector;
  final double highSector;
  final double lastvalue;

  // ignore: use_key_in_widget_constructors
  const GaugeWidget(
      {
      required this.ioT,
      required this.measurement,
      required this.units,
      required this.value,
      this.decimalPlaces = 2,
      this.lastvalue = 0,
      this.bottomRange = 0,
      this.topRange = 100,
      this.highColor = Colors.red,
      this.medColor = Colors.orange,
      this.lowColor = Colors.green,
      this.highSector = 40.0,
      this.medSector = 40.0,
      this.lowSector = 20.0});

  @override
  State<GaugeWidget> createState() => _GaugeWidgetState();
}

class _GaugeWidgetState extends State<GaugeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double read = getValue(widget.value);
    double reading = getMeter(widget.value);
    var step = (this.widget.topRange - this.widget.bottomRange) / 1000;
    return TimerBuilder.periodic(const Duration(milliseconds: 5), builder: (context) {
      read = getValue(widget.value);
      if (reading - step > read) {
        reading = reading - step;
      } else if (reading + step < read) {
        reading = reading + step;
      } else {
        reading = read;
      }
      setMeter(widget.value, reading);

      return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        PrettyGauge(
          gaugeSize: 270,
          currentValueDecimalPlaces: widget.decimalPlaces,
          minValue: widget.bottomRange,
          maxValue: widget.topRange,
          segments: [
            GaugeSegment('Low', widget.lowSector, widget.lowColor),
            GaugeSegment('Medium', widget.medSector, widget.medColor),
            GaugeSegment('High', widget.highSector, widget.highColor),
          ],
          currentValue: reading,
          displayWidget:
              Text(widget.measurement, style: const TextStyle(fontSize: 12)),
        ),
        Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.units,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ))
      ]);

      // return  Text("${DateTime.now()}");
    });
  }

  double getValue(String value) {
    String? result;
    switch (value) {
      case 'sensorName':
        result = widget.ioT.sensorName;
        break;
      case 'heartRate':
        result = widget.ioT.heartRate;
        break;
      case 'bloodOxygen':
        result = widget.ioT.bloodOxygen;
        break;
      case 'time':
        result = widget.ioT.time;
        break;
      default:
        result = "0.0";
        break;
    }
    return (double.parse(result!));
  }

  double getMeter(String value) {
    String? result;
    switch (value) {
      case 'heartRate':
        result = widget.ioT.meterHeartRate;
        break;
      case 'bloodOxygen':
        result = widget.ioT.meterBloodOxygen;
        break;
      default:
        result = "0.0";
        break;
    }
    return (double.parse(result!));
  }

  setMeter(String value, double reading) {
    switch (value) {
      case 'heartRate':
        widget.ioT.meterHeartRate = reading.toString();
        break;
      case 'bloodOxygen':
        widget.ioT.meterBloodOxygen = reading.toString();
        break;
      default:
        break;
    }
  }
}
