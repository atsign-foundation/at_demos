import 'package:max30101/max30101.dart';

late Max30101 pulseOxymeter;

void onBeat(bool beatDetected, double bpm, double sao2) {
  printWithTimestamp ("onBeat called with beatDetected:$beatDetected bpm:$bpm sao2:$sao2");
}

void main() {
  Max30101 max30101 = Max30101(RealI2CWrapper(1), false, debug:false);

  max30101.runSampler(onBeat);
}
