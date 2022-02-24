abstract class I2CWrapper {
  int readByteReg(int address, int register);
  void writeByteReg(int address, int register, int byteValue);
  List<int> readBytesReg(int address, int register, int len);
}
