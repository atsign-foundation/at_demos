import 'i2c_wrapper.dart';

class FakeI2CWrapper implements I2CWrapper {
  Map<int, int> fakeRegisterValues = {};

  @override
  int readByteReg(int address, int register) {
    int? val = fakeRegisterValues[register];
    val ??= 0;
    return val;
  }

  @override
  void writeByteReg(int address, int register, int byteValue) {
    fakeRegisterValues[register] = byteValue;
  }

  @override
  List<int> readBytesReg(int address, int register, int len) {
    return List.filled(len, 0);
  }
}
