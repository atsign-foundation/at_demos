// ignore_for_file: constant_identifier_names, non_constant_identifier_names, camel_case_types

import 'dart:io';
import 'dart:math';

import 'i2c_wrapper.dart';

const int RESET_SPO2_EVERY_N_PULSES = 4;

const double ALPHA = 0.95;  //dc filter alpha value
const int MEAN_FILTER_SIZE = 15;

const int PULSE_MIN_THRESHOLD = 100; //300 is good for finger, but for wrist you need like 20, and there is sh*t-loads of noise
const int PULSE_MAX_THRESHOLD = 2000;
const int PULSE_GO_DOWN_THRESHOLD = 1;

const int PULSE_BPM_SAMPLE_SIZE = 10; //Moving average size

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
  PULSE_IDLE,
  PULSE_TRACE_UP,
  PULSE_TRACE_DOWN
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
  List<double> values = List<double>.filled(MEAN_FILTER_SIZE, 0.0, growable:false); // size is [MEAN_FILTER_SIZE];
  int index = 0;
  double sum = 0;
  int count = 0;
}

const int Max30101DeviceAddress = 0x57;

class Bits {
  String name;
  String _mask;
  List<int> bitNumbers = [];
  Map<dynamic, String> adapter;

  Bits(this.name, this._mask, this.adapter) {
    for (int maskIndex = _mask.length - 1, bitNumberIndex = 0; maskIndex >= 0; maskIndex--, bitNumberIndex++) {
      if (_mask[maskIndex] == '1') {
        bitNumbers.add(bitNumberIndex);
      }
    }
  }

  @override String toString() {
    return "Bits:{name:$name, mask:$_mask, bitNumbers:$bitNumbers, adapter:$adapter}\n";
  }


  get mask => _mask;
}

class Register {
  String name;
  int address;
  Map<String, Bits> bits = {};

  Register(this.name, this.address);

  addBits(String name, String mask, Map<dynamic, String> adapter) {
    bits[name] = Bits(name, mask, adapter);
  }

  @override String toString() {
    return "Register:{name:$name, address:$address, bits:$bits}";
  }
}


class MAX30101 {
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

  static int setBits(int inputValue, String registerName, String bitsName, dynamic value) {
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
      return _setSingleBit(inputValue, register, bits, value);
    } else { // set a group of bits to a value we look up from our adapter map based on supplied value
      return _setMultipleBits(inputValue, register, bits, value);
    }
  }

  static int _setMultipleBits(int inputValue, Register register, Bits bits, dynamic value) {
    String? valueLookup = bits.adapter[value];
    if (valueLookup == null) {
      throw Exception("Value $value is not mapped to a bitmask for ${register.name}.${bits.name}");
    }
    if (valueLookup.length != bits.bitNumbers.length) {
      throw Exception("Bad mapping: looked up $value and got $valueLookup which has length ${valueLookup
          .length}, but ${register.name}.${bits.name} has mask ${bits.mask} length ${bits.bitNumbers.length}");
    }

    int outputValue = inputValue;

    for (int bitNumberIndex = 0, valueIndex = bits.bitNumbers.length-1; bitNumberIndex < bits.bitNumbers.length; bitNumberIndex++, valueIndex--) {
      int bitNumber = bits.bitNumbers[bitNumberIndex];
      if (valueLookup[valueIndex] == '1') {
        outputValue = BW.setBit(inputValue, bitNumber);
      } else {
        outputValue = BW.clearBit(inputValue, bitNumber);
      }
    }
    return outputValue;
  }

  static int _setSingleBit(int inputValue, Register register, Bits bits, dynamic value) {
    // value must be boolean
    if (value is! bool) {
      throw Exception("${register.name}.${bits.name} is single bit, value must be boolean but was $value");
    }
    else {
      int outputValue = inputValue;

      if (value == true) {
        outputValue = BW.setBit(inputValue, bits.bitNumbers[0]);
      } else {
        outputValue = BW.clearBit(inputValue, bits.bitNumbers[0]);
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

  I2CWrapper wrapper;

  /// Check table 8 in datasheet on page 19. You can't just throw in sample rate and pulse width randomly.
  /// 100hz + 1600us is max for that resolution
  /// device is injectable so you can inject mocks / whatever for testing purposes
  MAX30101(this.wrapper, {this.ledPower = 6.4, this.ledsEnabled = 2,
            this.sampleRate = 400, this.sampleAverage = 4,
            this.pulseWidth = 215, this.adcRange = 16384,
            this.highResMode = true, this.debug = true})
  {
    if (ledsEnabled < 2 || ledsEnabled > 3) {
      throw Exception("ledsEnabled must be 2 or 3. Preferably 2 (Red and InfraRed)");
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
  int redLEDCurrent = 0;
  int lastREDLedCurrentCheck = 0;

  PulseStateMachine currentPulseDetectorState = PulseStateMachine.PULSE_IDLE;
  double currentBPM = 0;
  List<double> valuesBPM = List<double>.filled(PULSE_BPM_SAMPLE_SIZE, 0, growable:false);
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
      int sampleRate = 400,
      int pulseWidth = 215,
      int adcRange = 16384,
      int timeoutMillis = 500}) {
    softReset(timeoutMillis: timeoutMillis);

    int fifoConfigValue = readRegister('FIFO_CONFIG');
    fifoConfigValue = setBits(fifoConfigValue, 'FIFO_CONFIG', 'sample_average', sampleAverage);
    fifoConfigValue = setBits(fifoConfigValue, 'FIFO_CONFIG', 'fifo_rollover_en', true);
    writeRegister('FIFO_CONFIG', fifoConfigValue);

    int spo2ConfigValue = readRegister('SPO2_CONFIG');
    spo2ConfigValue = setBits(spo2ConfigValue, 'SPO2_CONFIG', 'sample_rate_sps', sampleRate);
    spo2ConfigValue = setBits(spo2ConfigValue, 'SPO2_CONFIG', 'adc_range_nA', adcRange);
    spo2ConfigValue = setBits(spo2ConfigValue, 'SPO2_CONFIG', 'led_pw_us', pulseWidth);
    writeRegister('SPO2_CONFIG', spo2ConfigValue);

    // See table 8 in https://datasheets.maximintegrated.com/en/ds/MAX30101.pdf
    writeRegister('LED1_PULSE_AMPLITUDE', (ledPower / 0.2).floor());
    writeRegister('LED2_PULSE_AMPLITUDE', (ledPower / 0.2).floor());
    writeRegister('LED3_PULSE_AMPLITUDE', (ledPower / 0.2).floor());

    // LED_PROX_PULSE_AMPLITUDE, register 0x10, does not exist for the MAX30101. Presumably it did for the MAX30105
    // writeRegister('LED_PROX_PULSE_AMPLITUDE', (ledPower / 0.2).floor());

    int modeConfigValue = readRegister('MODE_CONFIG');
    modeConfigValue = setBits(modeConfigValue, 'MODE_CONFIG', 'mode', ledsEnabled);
    writeRegister('MODE_CONFIG', modeConfigValue);

    int ledModeValue = readRegister('LED_MODE_CONTROL_SLOTS_1_2');
    ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_1_2', 'slot1', 'red');
    if (ledsEnabled >= 2) {
      ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_1_2', 'slot2', 'ir');
    } else {
      ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_1_2', 'slot2', 'off');
    }
    writeRegister('LED_MODE_CONTROL_SLOTS_1_2', ledModeValue);

    if (ledsEnabled >= 3) {
      ledModeValue = readRegister('LED_MODE_CONTROL_SLOTS_3_4');
      ledModeValue = setBits(ledModeValue, 'LED_MODE_CONTROL_SLOTS_3_4', 'slot3', 'red');
      writeRegister('LED_MODE_CONTROL_SLOTS_3_4', ledModeValue);
    }

    clearFIFO();
  }

  void softReset({timeoutMillis = 500}) {
    // read the MODE_CONFIG register; set the reset bit; write the register; re-read the register until reset bit is zero again
    int modeConfigValue = readRegister('MODE_CONFIG');
    modeConfigValue = setBits(modeConfigValue, 'MODE_CONFIG', 'reset', true);
    writeRegister('MODE_CONFIG', modeConfigValue);

    int startTime = DateTime.now().millisecondsSinceEpoch;
    while (DateTime.now().millisecondsSinceEpoch - startTime < timeoutMillis) {
      int configValue = readRegister('MODE_CONFIG');
      if (! BW.isBitSet(configValue, _registerMap['MODE_CONFIG']!.bits['reset']!.bitNumbers[0])) {
        break;
      }
      sleep(Duration(milliseconds: 50));
    }
  }

  void clearFIFO() {
    writeRegister('FIFO_READ', 0);
    writeRegister('FIFO_WRITE', 0);
    writeRegister('FIFO_OVERFLOW', 0);
  }

  /// Writes val to address register on device
  int writeRegister(String registerName, int byteValue) { // byte arguments
    if (debug) {
      print("Writing $byteValue to $registerName");
    }
    wrapper.writeByteReg(Max30101DeviceAddress, _registerMap[registerName]!.address, byteValue);
    return byteValue;
  }

  // byte argument, byte return
  int readRegister(String registerName) {
    var byteValue = wrapper.readByteReg(Max30101DeviceAddress, _registerMap[registerName]!.address);
    if (debug) {
      print("Read $byteValue from $registerName");
    }
    return byteValue;
  }

  // Reads num bytes starting from address register on device in to _buff array
  List<int> readFrom(String registerName, int len) {
    var byteValuesRead = wrapper.readBytesReg(Max30101DeviceAddress, _registerMap[registerName]!.address, len);
    if (debug) {
      print("Read ${byteValuesRead.length} bytes from $registerName : $byteValuesRead");
    }
    return byteValuesRead;
  }

  List<SensorFIFOSample> readFIFO() {
    int fifoReadPointer = readRegister('FIFO_READ');
    int fifoWritePointer = readRegister('FIFO_WRITE');
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
      data.addAll(readFrom('FIFO_DATA', min(bytesToRead, 32)));
      bytesToRead -= 32;
    }

    clearFIFO();

    List<SensorFIFOSample> result = [];

    for (int i = 0; i < data.length; i+=3 * ledsEnabled) {
      SensorFIFOSample sample = SensorFIFOSample();
      // 3 bytes for each LED : IR, Red, Green
      sample.rawIR = data[i] << 16 | data[i+1] << 8 | data[i+2];
      sample.rawRed = data[i+3] << 16 | data[i+4] << 8 | data[i+5];
      if (ledsEnabled >= 3) {
        sample.rawGreen = data[i+6] << 16 | data[i+7] << 8 | data[i+8];
      }

      result.add(sample);
    }

    return result;
  }

  Future<void> runSampler(Function(bool beatDetected, double bpm, double sao2) onBeat) async {
    int thisSampleTime = 0;

    int lastCalledOnBeat = DateTime.now().microsecondsSinceEpoch;

    int microsBetweenSamples = (1000000 / sampleRate).round();

    while (true) {
      // take sample from the device and process it
      PulseOxymeterData sampleResult = update();
      thisSampleTime = DateTime.now().microsecondsSinceEpoch;

      if (sampleResult.pulseDetected || DateTime.now().microsecondsSinceEpoch - lastCalledOnBeat > 500) {
        onBeat(sampleResult.pulseDetected, sampleResult.heartBPM, sampleResult.saO2);
        lastCalledOnBeat = DateTime.now().microsecondsSinceEpoch;
      }

      // Need to wait until millisBetweenSamples milliseconds have passed before taking next sample
      int nextSampleTime = thisSampleTime + microsBetweenSamples;
      int waitTimeInMicros = nextSampleTime - DateTime.now().microsecondsSinceEpoch;
      if (waitTimeInMicros > 0) {
        await Future.delayed(Duration(microseconds: waitTimeInMicros));
      }
    }
  }

  PulseOxymeterData update() {
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

    List<SensorFIFOSample> fifoSampleList = readFIFO();

    for (int i = 0; i < fifoSampleList.length; i++) {
      SensorFIFOSample sample = fifoSampleList[i];

      dcFilterIR = dcRemoval(sample.rawIR.toDouble(), dcFilterIR.w, ALPHA);
      dcFilterRed = dcRemoval(sample.rawRed.toDouble(), dcFilterRed.w, ALPHA);

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
          print("RMS Ratio: $ratioRMS");
        }

        //This is the adjusted standard model, so it shows 0.89 as 94% saturation. It is probably far from correct, requires proper empirical calibration
        currentSaO2Value = 110.0 - 18.0 * ratioRMS;
        result.saO2 = currentSaO2Value;

        if (pulsesDetected % RESET_SPO2_EVERY_N_PULSES == 0) {
          irACValueSqSum = 0;
          redACValueSqSum = 0;
          samplesRecorded = 0;
        }
      }
    }

    result.heartBPM = currentBPM;
    result.irCardiogram = lpbFilterIR.result;
    result.irDcValue = dcFilterIR.w;
    result.redDcValue = dcFilterRed.w;
    result.lastBeatThreshold = lastBeatThreshold;
    result.dcFilteredIR = dcFilterIR.result;
    result.dcFilteredRed = dcFilterRed.result;


    return result;
  }

  double  prev_sensor_value = 0;
  int values_went_down = 0;
  int currentBeat = 0;
  int lastBeat = 0;
  bool detectPulse(double sensor_value) {
    if (sensor_value > PULSE_MAX_THRESHOLD) {
      currentPulseDetectorState = PulseStateMachine.PULSE_IDLE;
      prev_sensor_value = 0;
      lastBeat = 0;
      currentBeat = 0;
      values_went_down = 0;
      lastBeatThreshold = 0;
      return false;
    }

    switch (currentPulseDetectorState) {
      case PulseStateMachine.PULSE_IDLE:
        if (sensor_value >= PULSE_MIN_THRESHOLD) {
          currentPulseDetectorState = PulseStateMachine.PULSE_TRACE_UP;
          values_went_down = 0;
        }
        break;

      case PulseStateMachine.PULSE_TRACE_UP:
        if (sensor_value > prev_sensor_value) {
          currentBeat = DateTime.now().millisecondsSinceEpoch;
          lastBeatThreshold = sensor_value;
        }
        else {
          if (debug == true) {
            print("Peak reached: $sensor_value $prev_sensor_value");
          }

          int beatDuration = currentBeat - lastBeat;
          lastBeat = currentBeat;

          double rawBPM = 0;
          if (beatDuration > 0) {
            rawBPM = 60000.0 / beatDuration;
          }
          if (debug == true) {
            print("rawBPM: $rawBPM");
          }

//This method sometimes glitches, it's better to go through whole moving average everytime
//IT's a neat idea to optimize the amount of work for moving avg. but while placing, removing finger it can screw up
//valuesBPMSum -= valuesBPM[bpmIndex];
//valuesBPM[bpmIndex] = rawBPM;
//valuesBPMSum += valuesBPM[bpmIndex];

          valuesBPM[bpmIndex] = rawBPM;
          valuesBPMSum = 0;
          for (int i = 0; i < PULSE_BPM_SAMPLE_SIZE; i++) {
            valuesBPMSum += valuesBPM[i];
          }

          if (debug == true) {
            print("CurrentMoving Avg: $valuesBPM");
          }

          bpmIndex++;
          bpmIndex = bpmIndex % PULSE_BPM_SAMPLE_SIZE;

          if (valuesBPMCount < PULSE_BPM_SAMPLE_SIZE) {
            valuesBPMCount++;
          }

          currentBPM = valuesBPMSum / valuesBPMCount;
          if (debug == true) {
            print("Avg. BPM: $currentBPM");
          }

          currentPulseDetectorState = PulseStateMachine.PULSE_TRACE_DOWN;

          return true;
        }
        break;

      case PulseStateMachine.PULSE_TRACE_DOWN:
        if (sensor_value < prev_sensor_value) {
          values_went_down++;
        }

        if (sensor_value < PULSE_MIN_THRESHOLD) {
          currentPulseDetectorState = PulseStateMachine.PULSE_IDLE;
        }
        break;
    }

    prev_sensor_value = sensor_value;
    return false;
  }

  DCFilterData dcRemoval(double x, double prev_w, double alpha) {
    DCFilterData filtered = DCFilterData();

    filtered.w = x + alpha * prev_w;
    filtered.result = filtered.w - prev_w;

    return filtered;
  }

  void lowPassButterworthFilter(double x, ButterworthFilterData filterResult) {
    filterResult.v[0] = filterResult.v[1];

//Fs = 100Hz and Fc = 10Hz
    filterResult.v[1] = (2.452372752527856026e-1 * x) + (0.50952544949442879485 * filterResult.v[0]);

//Fs = 100Hz and Fc = 4Hz
//filterResult->v[1] = (1.367287359973195227e-1 * x) + (0.72654252800536101020 * filterResult->v[0]); //Very precise butterworth filter 

    filterResult.result = filterResult.v[0] + filterResult.v[1];
  }

  double meanDiff(double M, MeanDiffFilterData filterValues) {
    double avg = 0;

    filterValues.sum -= filterValues.values[filterValues.index];
    filterValues.values[filterValues.index] = M;
    filterValues.sum += filterValues.values[filterValues.index];

    filterValues.index++;
    filterValues.index = filterValues.index % MEAN_FILTER_SIZE;

    if (filterValues.count < MEAN_FILTER_SIZE) {
      filterValues.count++;
    }

    avg = filterValues.sum / filterValues.count;
    return avg - M;
  }
}

class BW {
  static int setBit(int byte, int bitNumber) {
    return byte | 1 << bitNumber;
  }
  static int clearBit(int byte, int bitNumber) {
    return byte & ~(1 << bitNumber);
  }
  static int toggleBit(int byte, int bitNumber) {
    return byte ^ 1 << bitNumber;
  }
  static bool isBitSet(int byte, bitNumber) {
    return ((byte >> bitNumber) & 1) == 1;
  }
}

