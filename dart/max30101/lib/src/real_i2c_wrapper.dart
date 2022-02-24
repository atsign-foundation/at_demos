import 'package:dart_periphery/dart_periphery.dart';
import 'i2c_wrapper.dart';

class RealI2CWrapper implements I2CWrapper {
  late I2C device;
  RealI2CWrapper(int busNum) {
    device = I2C(busNum);
  }

  @override int readByteReg(int address, int register) {
    return device.readByteReg(address, register);
  }

  @override List<int> readBytesReg(int address, int register, int len) {
    return device.readBytesReg(address, register, len);
  }

  @override void writeByteReg(int address, int register, int byteValue) {
    device.writeByteReg(address, register, byteValue);
  }
}

