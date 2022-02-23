
///
/// Line-by-line port of https://morf.lv/implementing-pulse-oximeter-using-max30100
///

// ignore_for_file: constant_identifier_names, non_constant_identifier_names, camel_case_types

import 'dart:io';
import 'dart:math';
import 'package:dart_periphery/dart_periphery.dart';

/* MAX30100 parameters */
const int DEFAULT_OPERATING_MODE = Mode.MAX30100_MODE_SPO2_HR;

/*!!!IMPORTANT
 * You can't just throw these two values at random. Check Check table 8 in datasheet on page 19.
 * 100hz + 1600us is max for that resolution
 */
const int DEFAULT_SAMPLING_RATE = SamplingRate.MAX30100_SAMPLING_RATE_100HZ;
const int DEFAULT_LED_PULSE_WIDTH = LEDPulseWidth.MAX30100_PULSE_WIDTH_1600US_ADC_16;

const int DEFAULT_IR_LED_CURRENT = LEDCurrent.MAX30100_LED_CURRENT_50MA;
const int STARTING_RED_LED_CURRENT = LEDCurrent.MAX30100_LED_CURRENT_27_1MA;

/* Adjust RED LED current balancing*/
const int MAGIC_ACCEPTABLE_INTENSITY_DIFF = 65000;
const int RED_LED_CURRENT_ADJUSTMENT_MS = 500;

/* SaO2 parameters */
const int RESET_SPO2_EVERY_N_PULSES = 4;

/* Filter parameters */
const double ALPHA = 0.95;  //dc filter alpha value
const int MEAN_FILTER_SIZE = 15;

/* Pulse detection parameters */
const int PULSE_MIN_THRESHOLD = 100; //300 is good for finger, but for wrist you need like 20, and there is sh*t-loads of noise
const int PULSE_MAX_THRESHOLD = 2000;
const int PULSE_GO_DOWN_THRESHOLD = 1;

const int PULSE_BPM_SAMPLE_SIZE = 10; //Moving average size





/* Enums, data structures and typdefs. DO NOT EDIT */
class pulseoxymeter_t {
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

class fifo_t {
  int rawIR = 0;
  int rawRed = 0;
}

class dcFilter_t {
  double w = 0;
  double result = 0;
}

class butterworthFilter_t {
  List<double> v = [0,0]; // size is 2
  double result = 0.0;
}

class meanDiffFilter_t {
  List<double> values = List<double>.filled(MEAN_FILTER_SIZE, 0.0, growable:false); // size is [MEAN_FILTER_SIZE];
  int index = 0;
  double sum = 0;
  int count = 0;
}

/* MAX30100 register and bit defines, DO NOT EDIT */
const int MAX30100_DEVICE_ADDRESS = 0x57;

//Part ID Registers
const int MAX30100_REV_ID = 0xFE;
const int MAX30100_PART_ID = 0xFF;

//status registers
const int MAX30100_INT_STATUS = 0x00;
const int MAX30100_INT_ENABLE = 0x01;

//Fifo registers
const int MAX30100_FIFO_WRITE = 0x02;
const int MAX30100_FIFO_OVERFLOW_COUNTER = 0x03;
const int MAX30100_FIFO_READ = 0x04;
const int MAX30100_FIFO_DATA = 0x05;

//Config registers
const int MAX30100_MODE_CONF = 0x06;
const int MAX30100_SPO2_CONF = 0x07;
const int MAX30100_LED_CONF = 0x09;

//Temperature registers
const int MAX30100_TEMP_INT = 0x16;
const int MAX30100_TEMP_FRACTION = 0x17;


//Bit defines MODE Register
const int MAX30100_MODE_SHDN = (1<<7);
const int MAX30100_MODE_RESET = (1<<6);
const int MAX30100_MODE_TEMP_EN = (1<<3);

class Mode {
  static const int MAX30100_MODE_HR_ONLY                 = 0x02;
  static const int MAX30100_MODE_SPO2_HR                 = 0x03;
}

//Bit defines SpO2 register
const int MAX30100_SPO2_HI_RES_EN = (1 << 6);

class SamplingRate {
  static const int MAX30100_SAMPLING_RATE_50HZ = 0x00;
  static const int MAX30100_SAMPLING_RATE_100HZ = 0x01;
  static const int MAX30100_SAMPLING_RATE_167HZ = 0x02;
  static const int MAX30100_SAMPLING_RATE_200HZ = 0x03;
  static const int MAX30100_SAMPLING_RATE_400HZ = 0x04;
  static const int MAX30100_SAMPLING_RATE_600HZ = 0x05;
  static const int MAX30100_SAMPLING_RATE_800HZ = 0x06;
  static const int MAX30100_SAMPLING_RATE_1000HZ = 0x07;
}

class LEDPulseWidth {
  static const int MAX30100_PULSE_WIDTH_200US_ADC_13     = 0x00;
  static const int MAX30100_PULSE_WIDTH_400US_ADC_14     = 0x01;
  static const int MAX30100_PULSE_WIDTH_800US_ADC_15     = 0x02;
  static const int MAX30100_PULSE_WIDTH_1600US_ADC_16    = 0x03;
}

class LEDCurrent {
  static const int MAX30100_LED_CURRENT_0MA              = 0x00;
  static const int MAX30100_LED_CURRENT_4_4MA            = 0x01;
  static const int MAX30100_LED_CURRENT_7_6MA            = 0x02;
  static const int MAX30100_LED_CURRENT_11MA             = 0x03;
  static const int MAX30100_LED_CURRENT_14_2MA           = 0x04;
  static const int MAX30100_LED_CURRENT_17_4MA           = 0x05;
  static const int MAX30100_LED_CURRENT_20_8MA           = 0x06;
  static const int MAX30100_LED_CURRENT_24MA             = 0x07;
  static const int MAX30100_LED_CURRENT_27_1MA           = 0x08;
  static const int MAX30100_LED_CURRENT_30_6MA           = 0x09;
  static const int MAX30100_LED_CURRENT_33_8MA           = 0x0A;
  static const int MAX30100_LED_CURRENT_37MA             = 0x0B;
  static const int MAX30100_LED_CURRENT_40_2MA           = 0x0C;
  static const int MAX30100_LED_CURRENT_43_6MA           = 0x0D;
  static const int MAX30100_LED_CURRENT_46_8MA           = 0x0E;
  static const int MAX30100_LED_CURRENT_50MA             = 0x0F;
}

// END OF .h file


// .cpp file starts here

class MAX30100 {
  int mode = DEFAULT_OPERATING_MODE;
  int samplingRate = DEFAULT_SAMPLING_RATE;
  int millisBetweenSamples = 10;
  int pulseWidth = DEFAULT_LED_PULSE_WIDTH;
  int IrLedCurrent = DEFAULT_IR_LED_CURRENT;
  bool highResMode = true;
  bool debug = false;

  late I2C device;

  /// Check table 8 in datasheet on page 19. You can't just throw in sample rate and pulse width randomly.
  /// 100hz + 1600us is max for that resolution
  /// device is injectable so you can inject mocks / whatever for testing purposes
  MAX30100(
      {  this.mode = DEFAULT_OPERATING_MODE,
        this.samplingRate = DEFAULT_SAMPLING_RATE,
        this.millisBetweenSamples = 10,
        this.pulseWidth = DEFAULT_LED_PULSE_WIDTH,
        this.IrLedCurrent = DEFAULT_IR_LED_CURRENT,
        this.highResMode = true,
        this.debug = false,
        I2C? injectedDevice})
  {
    if (injectedDevice != null) {
      device = injectedDevice;
    } else {
      device = I2C(1);
    }

    setMode(mode);
    setSamplingRate(samplingRate);
    setLEDPulseWidth(pulseWidth);

    redLEDCurrent = STARTING_RED_LED_CURRENT;
    lastREDLedCurrentCheck = 0;

    IrLedCurrent = IrLedCurrent;
    setLEDCurrents(redLEDCurrent, IrLedCurrent );
    setHighresModeEnabled(highResMode);

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

  fifo_t prevFifo = fifo_t();

  dcFilter_t dcFilterIR = dcFilter_t();
  dcFilter_t dcFilterRed = dcFilter_t();
  butterworthFilter_t lpbFilterIR = butterworthFilter_t();
  meanDiffFilter_t meanDiffIR = meanDiffFilter_t();

  double irACValueSqSum = 0;
  double redACValueSqSum = 0;
  int samplesRecorded = 0;
  int pulsesDetected = 0;
  double currentSaO2Value = 0;

  Future<void> runSampler(Function(bool beatDetected, double bpm, double sao2) onBeat) async {
    int prevSampleTime = DateTime.now().millisecondsSinceEpoch;
    int thisSampleTime = 0;
    while (true) {
      pulseoxymeter_t sampleResult = update();

      prevSampleTime = thisSampleTime;
      thisSampleTime = DateTime.now().millisecondsSinceEpoch;

      if (sampleResult.pulseDetected || thisSampleTime - prevSampleTime > 500) {
        onBeat(sampleResult.pulseDetected, sampleResult.heartBPM, sampleResult.saO2);
      }

      // Need to wait until millisBetweenSamples milliseconds have passed before taking next sample
      int nextSampleTime = prevSampleTime + millisBetweenSamples;
      int waitTime = nextSampleTime - DateTime.now().millisecondsSinceEpoch;
      if (waitTime > 0) {
        await Future.delayed(Duration(milliseconds: waitTime));
      }
    }
  }

  pulseoxymeter_t update() {
    pulseoxymeter_t result = pulseoxymeter_t()
      ..pulseDetected = false
      ..heartBPM = .0
      ..irCardiogram = 0.0
      ..irDcValue = 0.0
      ..redDcValue = 0.0
      ..saO2 = currentSaO2Value
      ..lastBeatThreshold = 0
      ..dcFilteredIR = 0.0
      ..dcFilteredRed = 0.0;

    fifo_t rawData = readFIFO();

    dcFilterIR = dcRemoval(rawData.rawIR.toDouble(), dcFilterIR.w, ALPHA);
    dcFilterRed = dcRemoval(rawData.rawRed.toDouble(), dcFilterRed.w, ALPHA);

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

//This is my adjusted standard model, so it shows 0.89 as 94% saturation. It is probably far from correct, requires proper empirical calibration
      currentSaO2Value = 110.0 - 18.0 * ratioRMS;
      result.saO2 = currentSaO2Value;

      if (pulsesDetected % RESET_SPO2_EVERY_N_PULSES == 0) {
        irACValueSqSum = 0;
        redACValueSqSum = 0;
        samplesRecorded = 0;
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

  void balanceIntensities(double redLedDC, double IRLedDC) {
    if (DateTime.now().millisecondsSinceEpoch - lastREDLedCurrentCheck >= RED_LED_CURRENT_ADJUSTMENT_MS) {
//Serial.println( redLedDC - IRLedDC );
      if (IRLedDC - redLedDC > MAGIC_ACCEPTABLE_INTENSITY_DIFF && redLEDCurrent < LEDCurrent.MAX30100_LED_CURRENT_50MA) {
        redLEDCurrent++;
        setLEDCurrents(redLEDCurrent, IrLedCurrent);
        if (debug == true) {
          print("RED LED Current +");
        }
      }
      else if (redLedDC - IRLedDC > MAGIC_ACCEPTABLE_INTENSITY_DIFF && redLEDCurrent > 0) {
        redLEDCurrent--;
        setLEDCurrents(redLEDCurrent, IrLedCurrent);
        if (debug == true) {
          print("RED LED Current -");
        }
      }

      lastREDLedCurrentCheck = DateTime.now().millisecondsSinceEpoch;
    }
  }

  /// Writes val to address register on device
  void writeRegister(int register, int byteValue) { // byte arguments
    device.writeByteReg(MAX30100_DEVICE_ADDRESS, register, byteValue);
  }

  // byte argument, byte return
  int readRegister(int register) {
    return device.readByteReg(MAX30100_DEVICE_ADDRESS, register);
  }

  // Reads num bytes starting from address register on device in to _buff array
  List<int> readFrom(int register, int len) {
    return device.readBytesReg(MAX30100_DEVICE_ADDRESS, register, len);
  }

  /// mode argument should be one of the values in the Mode class
  void setMode(int mode) {
    int currentModeReg = readRegister(MAX30100_MODE_CONF); // currentModeReg is a byte
    writeRegister(MAX30100_MODE_CONF, (currentModeReg & 0xF8) | mode);
  }

  void setHighresModeEnabled(bool enabled) {
    int previous = readRegister(MAX30100_SPO2_CONF); // previous is a byte
    if (enabled) {
      writeRegister(MAX30100_SPO2_CONF, previous | MAX30100_SPO2_HI_RES_EN);
    } else {
      writeRegister(MAX30100_SPO2_CONF, previous & ~MAX30100_SPO2_HI_RES_EN);
    }
  }

  /// rate needs be one of the values in the SamplingRate class
  void setSamplingRate(int rate) {
    int currentSpO2Reg = readRegister(MAX30100_SPO2_CONF);
    writeRegister(MAX30100_SPO2_CONF, (currentSpO2Reg & 0xE3) | (rate << 2));
  }

  /// pw needs to be one of the values in the LEDPulseWidth class
  void setLEDPulseWidth(int pw) {
    int currentSpO2Reg = readRegister(MAX30100_SPO2_CONF);
    writeRegister(MAX30100_SPO2_CONF, (currentSpO2Reg & 0xFC) | pw);
  }

  void setLEDCurrents(int redLedCurrent, int IRLedCurrent) {
    writeRegister(MAX30100_LED_CONF, (redLedCurrent << 4) | IRLedCurrent);
  }

  double readTemperature() {
    int currentModeReg = readRegister(MAX30100_MODE_CONF);
    writeRegister(MAX30100_MODE_CONF, currentModeReg | MAX30100_MODE_TEMP_EN);

    sleep(Duration(milliseconds: 100)); //This can be changed to a while loop, there is an interrupt flag for when temperature has been read.

    int temp = readRegister(MAX30100_TEMP_INT);
    double tempFraction = readRegister(MAX30100_TEMP_FRACTION) * 0.0625;

    return temp + tempFraction;
  }

  fifo_t readFIFO() {
    fifo_t result = fifo_t();

    List<int> fifoData_FourBytes = readFrom(MAX30100_FIFO_DATA, 4);

    result.rawIR = (fifoData_FourBytes[0] << 8) | fifoData_FourBytes[1];
    result.rawRed = (fifoData_FourBytes[2] << 8) | fifoData_FourBytes[3];

    return result;
  }

  dcFilter_t dcRemoval(double x, double prev_w, double alpha) {
    dcFilter_t filtered = dcFilter_t();

    filtered.w = x + alpha * prev_w;
    filtered.result = filtered.w - prev_w;

    return filtered;
  }

  void lowPassButterworthFilter(double x, butterworthFilter_t filterResult) {
    filterResult.v[0] = filterResult.v[1];

//Fs = 100Hz and Fc = 10Hz
    filterResult.v[1] = (2.452372752527856026e-1 * x) + (0.50952544949442879485 * filterResult.v[0]);

//Fs = 100Hz and Fc = 4Hz
//filterResult->v[1] = (1.367287359973195227e-1 * x) + (0.72654252800536101020 * filterResult->v[0]); //Very precise butterworth filter 

    filterResult.result = filterResult.v[0] + filterResult.v[1];
  }

  double meanDiff(double M, meanDiffFilter_t filterValues) {
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

  void printRegisters() {
    print(readRegister(MAX30100_INT_STATUS).toRadixString(16));
    print(readRegister(MAX30100_INT_ENABLE).toRadixString(16));
    print(readRegister(MAX30100_FIFO_WRITE).toRadixString(16));
    print(readRegister(MAX30100_FIFO_OVERFLOW_COUNTER).toRadixString(16));
    print(readRegister(MAX30100_FIFO_READ).toRadixString(16));
    print(readRegister(MAX30100_FIFO_DATA).toRadixString(16));
    print(readRegister(MAX30100_MODE_CONF).toRadixString(16));
    print(readRegister(MAX30100_SPO2_CONF).toRadixString(16));
    print(readRegister(MAX30100_LED_CONF).toRadixString(16));
    print(readRegister(MAX30100_TEMP_INT).toRadixString(16));
    print(readRegister(MAX30100_TEMP_FRACTION).toRadixString(16));
    print(readRegister(MAX30100_REV_ID).toRadixString(16));
    print(readRegister(MAX30100_PART_ID).toRadixString(16));
  }
}
