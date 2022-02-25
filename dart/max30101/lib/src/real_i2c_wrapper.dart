import 'package:dart_periphery/dart_periphery.dart';
import 'i2c_wrapper.dart';

class RealI2CWrapper implements I2CWrapper {
  late I2C device;
  RealI2CWrapper(int busNum) {
    device = I2C(busNum);
  }

  @override int readByteReg(int address, int register) {
    return device.readByteReg(address, register).toUnsigned(8);
  }

  @override List<int> readBytesReg(int address, int register, int len) {
    List<int> ints = device.readBytesReg(address, register, len);
    for (int i = 0; i < ints.length; i++) {
      ints[i] = ints[i].toUnsigned(8);
    }
    return ints;
  }

  @override void writeByteReg(int address, int register, int byteValue) {
    device.writeByteReg(address, register, byteValue);
  }
}

