import 'dart:io';
import 'dart:math';

import 'register_utils.dart';
import 'i2c_wrapper.dart';

const int resetSPO2EveryNPulses = 5;

/* Adjust RED LED current balancing*/
const int magicAcceptableLEDIntensityDiff = 65000;
const int redLEDCurrentAdjustmentMs = 250; // adjust red led intensity every 500 milliseconds
const int startingIRLEDCurrent = 64; // about 12.8 mA - see table 8 "LED Current Control"
const int startingRedLEDCurrent = 32; // about 6.4 mA - see table 8 "LED Current Control"

const double alpha = 0.95;  //dc filter alpha value
const int meanFilterSize = 15;

const int pulseMinThreshold = 100; //300 is good for finger, but for wrist you need like 20, and there is sh*t-loads of noise
const int pulseMaxThreshold = 2000;
const int pulseGoDownThreshold = 1;

const int pulseBpmSampleSize = 10; //Moving average size

class PulseOxymeterData {
  bool pulseDetected = false;
  double heartBPM = 0;

  double irCardiogram = 0;

  double irDcValue = 0;
  double redDcValue = 0;

  double saO2 = 0;

  double lastBeatThreshold = 0;

  double dcFilteredIR = 0;
  double dcFilteredRed = 0;
}

enum PulseStateMachine {
  pulseIdle,
  pulseTraceUp,
  pulseTraceDown
}

class SensorFIFOSample {
  int rawIR = 0;
  int rawRed = 0;
  int rawGreen = 0;
}

class DCFilterData {
  double w = 0;
  double result = 0;
}

class ButterworthFilterData {
  List<double> v = [0,0]; // size is 2
  double result = 0.0;
}

class MeanDiffFilterData {
  List<double> values = List<double>.filled(meanFilterSize, 0.0, growable:false);
  int index = 0;
  double sum = 0;
  int count = 0;
}

const int max30101DeviceAddress = 0x57;

void printWithTimestamp(String message) {
  print('${DateTime.now().toIso8601String()} | $message');
}

class Max30101 {
  static final Map<String, Register> _registerMap = {};
  static Map<String, Register> getRegisterMap() {
    _setupRegisters();
    return _registerMap;
  }

  static void _setupRegisters() {
    if (_registerMap.isNotEmpty) {
      return;
    }

    _registerMap['FIFO_WRITE'] = Register('FIFO_WRITE', 0x04);
    _registerMap['FIFO_OVERFLOW'] = Register('FIFO_WRITE', 0x05);
    _registerMap['FIFO_READ'] = Register('FIFO_WRITE', 0x06);
    _registerMap['FIFO_DATA'] = Register('FIFO_WRITE', 0x07);

    _registerMap['FIFO_CONFIG'] = Register('FIFO_CONFIG', 0x08)
      ..addBits('sample_average', '11100000', {1: '000', 2: '001', 4: '010', 8: '011', 16: '100', 32: '101'})
      ..addBits('fifo_rollover_en', '00010000', {})
      ..addBits('fifo_almost_full', '00001111', {});

    _registerMap['MODE_CONFIG'] = Register('MODE_CONFIG', 0x09)
      ..addBits('shutdown', '10000000', {})
      ..addBits('reset', '01000000', {})
      ..addBits('mode', '00000111', {
        0: '000', // None
        1: '010', // Red only
        2: '011', // Red and IR
        3: '111' // Red, IR and Green
      });

    _registerMap['SPO2_CONFIG'] = Register('SPO2_CONFIG', 0x0A)
      ..addBits('adc_range_nA', '01100000', {2048: '00', 4096: '01', 8192: '10', 16384: '11'})
      ..addBits('sample_rate_sps', '00011100', {50:'000',100:'001',200:'010',400:'011',800:'100',1000:'101',1600:'110',3200:'111'})
      ..addBits('led_pw_us', '00000011', {69:'00',118:'01',215:'10',411:'11'});

    _registerMap['LED1_PULSE_AMPLITUDE'] = Register('LED1_PULSE_AMPLITUDE', 0x0C);
    _registerMap['LED2_PULSE_AMPLITUDE'] = Register('LED2_PULSE_AMPLITUDE', 0x0D);
    _registerMap['LED3_PULSE_AMPLITUDE'] = Register('LED3_PULSE_AMPLITUDE', 0x0E);
    _registerMap['LED4_PULSE_AMPLITUDE'] = Register('LED4_PULSE_AMPLITUDE', 0x0F);

    _registerMap['LED_MODE_CONTROL_SLOTS_1_2'] = Register('LED_MODE_CONTROL_SLOTS_1_2', 0x11)
      ..addBits('slot1', '00001111', {'off': '0000', 'red':'0001', 'ir':'0010', 'green':'0011'})
      ..addBits('slot2', '11110000', {'off': '0000', 'red':'0001', 'ir':'0010', 'green':'0011'});
    _registerMap['LED_MODE_CONTROL_SLOTS_3_4'] = Register('LED_MODE_CONTROL_SLOTS_3_4', 0x12)
      ..addBits('slot3', '00001111', {'off': '0000', 'red':'0001', 'ir':'0010', 'green':'0011'})
      ..addBits('slot4', '11110000', {'off': '0000', 'red':'0001', 'ir':'0010', 'green':'0011'});
  }

  static int setBits(int byteValue, String registerName, String bitsName, dynamic value) {
    Register? register = _registerMap[registerName];
    if (register == null) {
      throw Exception("Register $registerName not mapped");
    }
    Bits? bits = register.bits[bitsName];
    if (bits == null) {
      throw Exception("Bits $bitsName not mapped for Register $registerName");
    }

    if (bits.bitNumbers.length == 1) { // set just one bit to true or false
      // value must be boolean
      return _setSingleBit(byteValue, register, bits, value);
    } else { // set a group of bits to a value we look up from our adapter map based on supplied value
      return _setMultipleBits(byteValue, register, bits, value);
    }
  }

  static int _setMultipleBits(int byteValue, Register register, Bits bits, dynamic value) {
    String? valueLookup = bits.adapter[value];
    if (valueLookup == null) {
      throw Exception("Value $value is not mapped to a bitmask for ${register.name}.${bits.name}");
    }
    if (valueLookup.length != bits.bitNumbers.length) {
      throw Exception("Bad mapping: looked up $value and got $valueLookup which has length ${valueLookup
          .length}, but ${register.name}.${bits.name} has mask ${bits.mask} length ${bits.bitNumbers.length}");
    }

    for (int bitNumberIndex = 0, valueIndex = bits.bitNumbers.length-1; bitNumberIndex < bits.bitNumbers.length; bitNumberIndex++, valueIndex--) {
      int bitNumber = bits.bitNumbers[bitNumberIndex];
      if (valueLookup[valueIndex] == '1') {
        byteValue = BitwiseOperators.setBit(byteValue, bitNumber);
      } else {
        byteValue = BitwiseOperators.clearBit(byteValue, bitNumber);
      }
    }
    return byteValue;
  }

  static int _setSingleBit(int inputValue, Register register, Bits bits, dynamic value) {
    // value must be boolean
    if (value is! bool) {
      throw Exception("${register.name}.${bits.name} is single bit, value must be boolean but was $value");
    }
    else {
      int outputValue = inputValue;

      if (value == true) {
        outputValue = BitwiseOperators.setBit(inputValue, bits.bitNumbers[0]);
      } else {
        outputValue = BitwiseOperators.clearBit(inputValue, bits.bitNumbers[0]);
      }

      return outputValue;
    }
  }

  double ledPower;
  int ledsEnabled;
  int sampleRate;
  int sampleAverage;
  int pulseWidth;
  int adcRange;
  bool highResMode = true;
  bool debug = false;

  bool captureSamples = true;
  late int captureStartTimeMicros;
  late File captureFile;
  I2CWrapper wrapper;

  /// Check table 8 in datasheet on page 19. You can't just throw in sample rate and pulse width randomly.
  /// 100hz + 1600us is max for that resolution
  /// device is injectable so you can inject mocks / whatever for testing purposes
  Max30101(this.wrapper, this.captureSamples, {this.ledPower = 6.4, this.ledsEnabled = 2,
            this.sampleRate = 100, this.sampleAverage = 1,
            this.pulseWidth = 411, this.adcRange = 16384,
            this.highResMode = true, this.debug = true})
  {
    if (captureSamples) {
      captureFile = File('max30101.capture.txt');
    }

    if (ledsEnabled < 2 || ledsEnabled > 3) {
      throw Exception("ledsEnabled must be 2 or 3. Preferably 2 (Red and InfraRed) because we don't do anything with green anyway");
    }

    _setupRegisters();

    setupDevice(
        ledPower: ledPower,
        sampleAverage: sampleAverage,
        ledsEnabled: ledsEnabled,
        sampleRate: sampleRate,
        pulseWidth: pulseWidth,
        adcRange: adcRange,
        timeoutMillis: 500);

    dcFilterIR.w = 0;
    dcFilterIR.result = 0;

    dcFilterRed.w = 0;
    dcFilterRed.result = 0;


    lpbFilterIR.v[0] = 0;
    lpbFilterIR.v[1] = 0;
    lpbFilterIR.result = 0;

    meanDiffIR.index = 0;
    meanDiffIR.sum = 0;
    meanDiffIR.count = 0;


    valuesBPM[0] = 0;
    valuesBPMSum = 0;
    valuesBPMCount = 0;
    bpmIndex = 0;


    irACValueSqSum = 0;
    redACValueSqSum = 0;
    samplesRecorded = 0;
    pulsesDetected = 0;
    currentSaO2Value = 0;

    lastBeatThreshold = 0;
  }

// private:
  int redLEDCurrent = startingRedLEDCurrent;
  int irLEDCurrent = startingIRLEDCurrent;

  int lastREDLedCurrentCheck = 0;

  PulseStateMachine currentPulseDetectorState = PulseStateMachine.pulseIdle;
  double currentBPM = 0;
  List<double> valuesBPM = List<double>.filled(pulseBpmSampleSize, 0, growable:false);
  double valuesBPMSum = 0;
  int valuesBPMCount = 0;
  int bpmIndex = 0;
  double lastBeatThreshold = 0;

  SensorFIFOSample prevFifo = SensorFIFOSample();

  DCFilterData dcFilterIR = DCFilterData();
  DCFilterData dcFilterRed = DCFilterData();
  ButterworthFilterData lpbFilterIR = ButterworthFilterData();
  MeanDiffFilterData meanDiffIR = MeanDiffFilterData();

  double irACValueSqSum = 0;
  double redACValueSqSum = 0;
  int samplesRecorded = 0;
  int pulsesDetected = 0;
  double currentSaO2Value = 0;



  //     def setup(self, led_power=6.4, sample_average=4, leds_enable=3, sample_rate=400, pulse_width=215, adc_range=16384, timeout=5.0):
  void setupDevice(
      {double ledPower = 6.4,
      int sampleAverage = 4,
      int ledsEnabled = 2,
      int sampleRate = 100,
      int pulseWidth = 215,
      int adcRange = 16384,
      int timeoutMillis = 500}) {
    softReset(timeoutMillis: timeoutMillis);

    int fifoConfigValue = readRegister('FIFO_CONFIG', true);
    fifoConfigValue = setBits(fifoConfigValue, 'FIFO_CONFIG', 'sample_average', sampleAverage);
    fifoConfigValue = setBits(fifoConfigValue, 'FIFO_CONFIG', 'fifo_rollover_en', true);
    writeRegister('FIFO_CONFIG', fifoConfigValue, true);

    //Check table 8 in datasheet on page 19. You can't just throw in sample rate and pulse width randomly. 100hz + 1600us is max for that resolution
    int spo2ConfigValue = readRegister('SPO2_CONFIG', true);
    spo2ConfigValue = setBits(spo2ConfigValue, 'SPO2_CONFIG', 'sample_rate_sps', sampleRate);
    spo2ConfigValue = setBits(spo2ConfigValue, 'SPO2_CONFIG', 'adc_range_nA', adcRange);
    spo2ConfigValue = setBits(spo2ConfigValue, 'SPO2_CONFIG', 'led_pw_us', pulseWidth);
    writeRegister('SPO2_CONFIG', spo2ConfigValue, true);

    int modeConfigValue = readRegister('MODE_CONFIG', true);
    modeConfigValue = setBits(modeConfigValue, 'MODE_CONFIG', 'mode', ledsEnabled);
    writeRegister('MODE_CONFIG', modeConfigValue, true);

    int ledModeValue = readRegister('LED_MODE_CONTROL_SLOTS_1_2', true);
    ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_1_2', 'slot1', 'red');
    if (ledsEnabled >= 2) {
      ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_1_2', 'slot2', 'ir');
    } else {
      ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_1_2', 'slot2', 'off');
    }
    writeRegister('LED_MODE_CONTROL_SLOTS_1_2', ledModeValue, true);

    if (ledsEnabled >= 3) {
      ledModeValue = readRegister('LED_MODE_CONTROL_SLOTS_3_4', true);
      ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_3_4', 'slot3', 'green');
      writeRegister('LED_MODE_CONTROL_SLOTS_3_4', ledModeValue, true);
    }

    lastREDLedCurrentCheck = 0;
    redLEDCurrent = startingRedLEDCurrent;
    irLEDCurrent = startingIRLEDCurrent;
    setLEDCurrents(redLEDCurrent, irLEDCurrent);

    clearFIFO(true);
  }

  void softReset({timeoutMillis = 500}) {
    printWithTimestamp("Soft reset");
    // read the MODE_CONFIG register; set the reset bit; write the register; re-read the register until reset bit is zero again
    int modeConfigValue = readRegister('MODE_CONFIG', true);
    modeConfigValue = setBits(modeConfigValue, 'MODE_CONFIG', 'reset', true);
    writeRegister('MODE_CONFIG', modeConfigValue, true);

    int startTime = DateTime.now().millisecondsSinceEpoch;
    while (DateTime.now().millisecondsSinceEpoch - startTime < timeoutMillis) {
      int configValue = readRegister('MODE_CONFIG', true);
      if (! BitwiseOperators.isBitSet(configValue, _registerMap['MODE_CONFIG']!.bits['reset']!.bitNumbers[0])) {
        break;
      }
      sleep(Duration(milliseconds: 250));
    }
  }

  void clearFIFO(bool logIt) {
    writeRegister('FIFO_READ', 0, logIt);
    writeRegister('FIFO_WRITE', 0, logIt);
    writeRegister('FIFO_OVERFLOW', 0, logIt);
  }

  Future<List<SensorFIFOSample>> readFIFO() async {
    int fifoReadPointer = readRegister('FIFO_READ', false);
    int fifoWritePointer = readRegister('FIFO_WRITE', false);
    if (fifoReadPointer == fifoWritePointer) {
      return [];
    }

    int numSamples = fifoWritePointer - fifoReadPointer;
    if (numSamples < 0) {
      numSamples = 32;
    }

    int bytesToRead = numSamples * 3 * ledsEnabled;
    List<int> data = [];
    while (bytesToRead > 0) {
      var bytesRead = readFrom('FIFO_DATA', min(bytesToRead, 32), false);
      data.addAll(bytesRead);
      if (captureSamples) {
        var logMessage = '${DateTime.now().microsecondsSinceEpoch - captureStartTimeMicros} | $bytesRead';
        await captureFile.writeAsString('$logMessage\n', flush: true, mode:FileMode.append);
        printWithTimestamp(logMessage);
      }
      bytesToRead -= 32;
    }

    clearFIFO(false);

    List<SensorFIFOSample> result = [];

    for (int i = 0; i < data.length; i+=3 * ledsEnabled) {
      SensorFIFOSample sample = SensorFIFOSample();
      // 3 bytes for each LED : Red, IR, Green
      sample.rawRed = data[i] << 16 | data[i+1] << 8 | data[i+2];
      sample.rawIR = data[i+3] << 16 | data[i+4] << 8 | data[i+5];
      if (ledsEnabled >= 3) {
        sample.rawGreen = data[i+6] << 16 | data[i+7] << 8 | data[i+8];
      }

      result.add(sample);
    }

    return result;
  }

  Future<void> runSampler(Function(bool beatDetected, double bpm, double sao2) onBeat) async {
    int lastReadAndCalculateTime = 0;

    clearFIFO(true);

    int lastCalledOnBeat = DateTime.now().microsecondsSinceEpoch;

    int microsBetweenSamples = (1000000 / sampleRate).round();

    captureStartTimeMicros = DateTime.now().microsecondsSinceEpoch;

    while (true) {
      // take sample from the device and process it
      PulseOxymeterData latestValues = await readSamplesAndCalculate();
      lastReadAndCalculateTime = DateTime.now().microsecondsSinceEpoch;

      if (latestValues.pulseDetected || DateTime.now().microsecondsSinceEpoch - lastCalledOnBeat > 2000000) {
        latestValues.saO2 = double.parse(latestValues.saO2.toStringAsFixed(1));
        latestValues.heartBPM = double.parse(latestValues.heartBPM.toStringAsFixed(1));

        printWithTimestamp ("runSampler calling onBeat called with beatDetected:${latestValues.pulseDetected} bpm:${latestValues.heartBPM} sao2:${latestValues.saO2}");

        onBeat(latestValues.pulseDetected, latestValues.heartBPM, latestValues.saO2);

        lastCalledOnBeat = DateTime.now().microsecondsSinceEpoch;
      }

      // Need to wait until millisBetweenSamples milliseconds have passed before taking next sample
      int nextSampleTime = lastReadAndCalculateTime + microsBetweenSamples;
      int waitTimeInMicros = nextSampleTime - DateTime.now().microsecondsSinceEpoch;
      if (waitTimeInMicros > 0) {
        await Future.delayed(Duration(microseconds: waitTimeInMicros));
      }
    }
  }

  Future<PulseOxymeterData> readSamplesAndCalculate() async {
    PulseOxymeterData result = PulseOxymeterData()
      ..pulseDetected = false
      ..heartBPM = .0
      ..irCardiogram = 0.0
      ..irDcValue = 0.0
      ..redDcValue = 0.0
      ..saO2 = currentSaO2Value
      ..lastBeatThreshold = 0
      ..dcFilteredIR = 0.0
      ..dcFilteredRed = 0.0;

    List<SensorFIFOSample> fifoSampleList = await readFIFO();

    for (int i = 0; i < fifoSampleList.length; i++) {
      SensorFIFOSample sample = fifoSampleList[i];

      dcFilterIR = dcRemoval(sample.rawIR.toDouble(), dcFilterIR.w, alpha);
      dcFilterRed = dcRemoval(sample.rawRed.toDouble(), dcFilterRed.w, alpha);

      double meanDiffResIR = meanDiff(dcFilterIR.result, meanDiffIR); // &meanDiffIR
      lowPassButterworthFilter(meanDiffResIR /*-dcFilterIR.result*/, lpbFilterIR); // &lpbFilterIR

      irACValueSqSum += dcFilterIR.result * dcFilterIR.result;
      redACValueSqSum += dcFilterRed.result * dcFilterRed.result;
      samplesRecorded++;

      if (detectPulse(lpbFilterIR.result) && samplesRecorded > 0) {
        result.pulseDetected = true;
        pulsesDetected++;

        double ratioRMS = log(sqrt(redACValueSqSum / samplesRecorded)) / log(sqrt(irACValueSqSum / samplesRecorded));

        if (debug == true) {
          printWithTimestamp("RMS Ratio: $ratioRMS");
        }

        //This is the adjusted standard model, so it shows 0.89 as 94% saturation. It is probably far from correct, requires proper empirical calibration
        double ratioToApply = ratioRMS;
        if (ratioToApply > 1.0) {
          ratioToApply = 1.0;
        }
        currentSaO2Value = 110.0 - 15.0 * ratioToApply;
        if (currentSaO2Value > 100) {
          currentSaO2Value = 100.0;
        }

        if (pulsesDetected % resetSPO2EveryNPulses == 0) {
          irACValueSqSum = 0;
          redACValueSqSum = 0;
          samplesRecorded = 0;
        }
      }
    }

    balanceIntensities(dcFilterRed.w, dcFilterIR.w);

    result.heartBPM = currentBPM;
    result.irCardiogram = lpbFilterIR.result;
    result.irDcValue = dcFilterIR.w;
    result.redDcValue = dcFilterRed.w;
    result.lastBeatThreshold = lastBeatThreshold;
    result.dcFilteredIR = dcFilterIR.result;
    result.dcFilteredRed = dcFilterRed.result;


    return result;
  }

  double  prevSensorValue = 0;
  int valuesWentDown = 0;
  int currentBeat = 0;
  int lastBeat = 0;
  bool detectPulse(double sensorValue) {
    if (sensorValue > pulseMaxThreshold) {
      currentPulseDetectorState = PulseStateMachine.pulseIdle;
      prevSensorValue = 0;
      lastBeat = 0;
      currentBeat = 0;
      valuesWentDown = 0;
      lastBeatThreshold = 0;
      return false;
    }

    switch (currentPulseDetectorState) {
      case PulseStateMachine.pulseIdle:
        if (sensorValue >= pulseMinThreshold) {
          currentPulseDetectorState = PulseStateMachine.pulseTraceUp;
          valuesWentDown = 0;
        }
        break;

      case PulseStateMachine.pulseTraceUp:
        if (sensorValue > prevSensorValue) {
          currentBeat = DateTime.now().millisecondsSinceEpoch;
          lastBeatThreshold = sensorValue;
        }
        else {
          if (debug == true) {
            printWithTimestamp("Peak reached: $sensorValue $prevSensorValue");
          }

          int beatDuration = currentBeat - lastBeat;
          lastBeat = currentBeat;

          double rawBPM = 0;
          if (beatDuration > 0) {
            rawBPM = 60000.0 / beatDuration;
          }
          if (debug == true) {
            printWithTimestamp("rawBPM: $rawBPM");
          }

          valuesBPM[bpmIndex] = rawBPM;
          valuesBPMSum = 0;
          for (int i = 0; i < pulseBpmSampleSize; i++) {
            valuesBPMSum += valuesBPM[i];
          }

          if (debug == true) {
            printWithTimestamp("CurrentMoving Avg: $valuesBPM");
          }

          bpmIndex++;
          bpmIndex = bpmIndex % pulseBpmSampleSize;

          if (valuesBPMCount < pulseBpmSampleSize) {
            valuesBPMCount++;
          }

          currentBPM = valuesBPMSum / valuesBPMCount;
          if (debug == true) {
            printWithTimestamp("Avg. BPM: $currentBPM");
          }

          currentPulseDetectorState = PulseStateMachine.pulseTraceDown;

          return true;
        }
        break;

      case PulseStateMachine.pulseTraceDown:
        if (sensorValue < prevSensorValue) {
          valuesWentDown++;
        }

        if (sensorValue < pulseMinThreshold) {
          currentPulseDetectorState = PulseStateMachine.pulseIdle;
        }
        break;
    }

    prevSensorValue = sensorValue;
    return false;
  }

  void balanceIntensities(double redLedDC, double irLedDC) {
    if (DateTime.now().millisecondsSinceEpoch - lastREDLedCurrentCheck >= redLEDCurrentAdjustmentMs) {

      if (irLedDC - redLedDC > magicAcceptableLEDIntensityDiff && redLEDCurrent < irLEDCurrent) {
        printWithTimestamp("RED LED Current ++");
        redLEDCurrent++;
        setLEDCurrents(redLEDCurrent, irLEDCurrent);
      }
      else if (redLedDC - irLedDC > magicAcceptableLEDIntensityDiff && redLEDCurrent > 0) {
        printWithTimestamp("RED LED Current --");
        redLEDCurrent--;
        setLEDCurrents(redLEDCurrent, irLEDCurrent);
      }

      lastREDLedCurrentCheck = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void setLEDCurrents(int _redLedCurrent, int _irLedCurrent) {
    writeRegister('LED1_PULSE_AMPLITUDE', _redLedCurrent, true);

    writeRegister('LED2_PULSE_AMPLITUDE', _irLedCurrent, true);
  }


  DCFilterData dcRemoval(double x, double previousW, double alpha) {
    DCFilterData filtered = DCFilterData();

    filtered.w = x + alpha * previousW;
    filtered.result = filtered.w - previousW;

    return filtered;
  }

  void lowPassButterworthFilter(double x, ButterworthFilterData filterResult) {
    filterResult.v[0] = filterResult.v[1];

    filterResult.v[1] = (2.452372752527856026e-1 * x) + (0.50952544949442879485 * filterResult.v[0]);

    filterResult.result = filterResult.v[0] + filterResult.v[1];
  }

  double meanDiff(double M, MeanDiffFilterData filterValues) {
    double avg = 0;

    filterValues.sum -= filterValues.values[filterValues.index];
    filterValues.values[filterValues.index] = M;
    filterValues.sum += filterValues.values[filterValues.index];

    filterValues.index++;
    filterValues.index = filterValues.index % meanFilterSize;

    if (filterValues.count < meanFilterSize) {
      filterValues.count++;
    }

    avg = filterValues.sum / filterValues.count;
    return avg - M;
  }

  int writeRegister(String registerName, int byteValue, logIt) { // byte arguments
    if (logIt) {
      printWithTimestamp("Writing $byteValue to $registerName");
    }
    wrapper.writeByteReg(max30101DeviceAddress, _registerMap[registerName]!.address, byteValue);
    return byteValue;
  }

  // byte argument, byte return
  int readRegister(String registerName, bool logIt) {
    var byteValue = wrapper.readByteReg(max30101DeviceAddress, _registerMap[registerName]!.address);
    if (logIt) {
      printWithTimestamp("Read $byteValue from $registerName");
    }
    return byteValue;
  }

  // Reads num bytes starting from a particular register address
  List<int> readFrom(String registerName, int numBytes, bool logIt) {
    var byteValuesRead = wrapper.readBytesReg(max30101DeviceAddress, _registerMap[registerName]!.address, numBytes);
    if (debug) {
      printWithTimestamp("Read ${byteValuesRead.length} bytes from $registerName : $byteValuesRead");
    }
    return byteValuesRead;
  }
}
