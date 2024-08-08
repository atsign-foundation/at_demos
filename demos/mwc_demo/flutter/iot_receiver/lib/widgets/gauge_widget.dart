// ignore_for_file: unnecessary_this

import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:iot_receiver/models/iot_model.dart';

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
  final double lastValue;

  // ignore: use_key_in_widget_constructors
  const GaugeWidget(
      {required this.ioT,
      required this.measurement,
      required this.units,
      required this.value,
      this.decimalPlaces = 2,
      this.lastValue = 0,
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
    setState(() {
      setMeter(widget.value, widget.bottomRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    double read = getValue(widget.value);
    double reading = getMeter(widget.value);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 160;
    // var mediaQuery = MediaQuery.of(context);
    // var _width = mediaQuery.size.width * mediaQuery.devicePixelRatio;
    // var _height = mediaQuery.size.height * mediaQuery.devicePixelRatio -160;
    double size;
    double font;
    if (width > height + 160) {
      size = width / 2;
      font = size / 9;
    } else {
      size = height / 2;
      if (width < height / 2) {
        size = width;
      }
    }
    font = size / 9;

    var step = (this.widget.topRange - this.widget.bottomRange) / 250;
    return TimerBuilder.periodic(const Duration(milliseconds: 5),
        builder: (context) {
      read = getValue(widget.value);
      if (reading - step > read) {
        reading = reading - step;
      } else if (reading + step < read) {
        if (reading < widget.bottomRange) {
          reading = widget.bottomRange;
        }
        reading = reading + step;
      } else {
        reading = read;
      }
      setMeter(widget.value, reading);

      return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        PrettyGauge(
          valueWidget: displayReading(read, font, widget.decimalPlaces),
          gaugeSize: size,
          startMarkerStyle: TextStyle(
              fontSize: font / 4,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          endMarkerStyle: TextStyle(
              fontSize: font / 4,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          currentValueDecimalPlaces: widget.decimalPlaces,
          minValue: widget.bottomRange,
          maxValue: widget.topRange,
          segments: [
            GaugeSegment('Low', widget.lowSector, widget.lowColor),
            GaugeSegment('Medium', widget.medSector, widget.medColor),
            GaugeSegment('High', widget.highSector, widget.highColor),
          ],
          currentValue: reading,
          displayWidget: displayUnits(widget.units, font),
        )
      ]);
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
      case 'heartTime':
        result = widget.ioT.heartTime;
        break;
      case 'oxygenTime':
        result = widget.ioT.oxygenTime;
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

  Widget displayReading(double reading, double fontSize, int decimalPlaces) {
    double max = 200;
    // Make sure the decimal place if supplied meets Darts bounds (0-20)
    if (decimalPlaces < 0) {
      decimalPlaces = 0;
    }
    if (decimalPlaces > 20) {
      decimalPlaces = 20;
    }
    if (fontSize > max) {
      fontSize = max;
    }
    return Column(
      children: [
        AutoSizeText(reading.toStringAsFixed(decimalPlaces),
            minFontSize: fontSize.truncateToDouble(),
            maxFontSize: max,
            style: TextStyle(
                fontSize: fontSize / 2,
                color: Colors.black87,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget displayUnits(String units, double fontSize) {
    fontSize = fontSize * .3;
    double max = 200;
    if (fontSize > max) {
      fontSize = max;
    }
    return Column(
      children: [
        AutoSizeText(widget.measurement,
            minFontSize: fontSize.truncateToDouble(),
            maxFontSize: max,
            style: TextStyle(
                fontSize: fontSize / 2,
                color: Colors.black87,
                fontWeight: FontWeight.bold)),
        AutoSizeText(units,
            minFontSize: fontSize.truncateToDouble(),
            maxFontSize: max,
            style: TextStyle(
                fontSize: fontSize / 2,
                color: Colors.black87,
                fontWeight: FontWeight.bold))
      ],
    );
  }
}
