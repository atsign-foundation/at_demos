import 'dart:io';

import 'package:max30101/max30101.dart';

late MAX30100 pulseOxymeter;

void main() {

  setup();

  loop();
}

void setup() {
  // TODO Once we've implemented PiWire (see end of max30101_example.dart) then we can test
  Wire wire = FakeWire();

  wire.begin();

  print ("Pulse oxymeter test!");

  //pulseOxymeter = new MAX30100( DEFAULT_OPERATING_MODE, DEFAULT_SAMPLING_RATE, DEFAULT_LED_PULSE_WIDTH, DEFAULT_IR_LED_CURRENT, true, true );
  pulseOxymeter = MAX30100(wire);

  // TODO [gary] I don't know what this does
  // pinMode(2, OUTPUT);

  pulseOxymeter.printRegisters();
}

void loop() {
  //return;
  //You have to call update with frequency at least 37Hz. But the closer you call it to 100Hz the better, the filter will work.
  pulseoxymeter_t result = pulseOxymeter.update();


  if( result.pulseDetected == true )
  {
  print("BEAT");

  print( "BPM: ${result.heartBPM} | SaO2 : ${result.SaO2}%");
  }


  //These are special packets for FlexiPlot plotting tool
  print("{P0|IR|0,0,255|${result.dcFilteredIR}|RED|255,0,0|${result.dcFilteredRed}}");

  print("{P1|RED|255,0,255|${result.irCardiogram}|BEAT|0,0,255|${result.lastBeatThreshold}}");

  sleep(Duration(milliseconds: 10));

  // TODO [gary] I don't know what this does
  //Basic way of determining execution of the loop via oscilloscope
  // digitalWrite( 2, !digitalRead(2));
}
