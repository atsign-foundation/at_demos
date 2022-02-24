import 'dart:io';

import 'package:max30101/max30101.dart';
import 'package:max30101/src/real_i2c_wrapper.dart';

late MAX30101 pulseOxymeter;

int maxCallbacks = 100;
int numCallbacks = 0;

void onBeat(bool beatDetected, double bpm, double sao2) {
  print ("onBeat called with beatDetected:$beatDetected bpm:$bpm sao2:$sao2");
  if (++numCallbacks >= maxCallbacks) {
    print ("Exiting");
    exit(0);
  }
}

void main() {
  MAX30101 max30100 = MAX30101(RealI2CWrapper(1));

  max30100.runSampler(onBeat);
}
