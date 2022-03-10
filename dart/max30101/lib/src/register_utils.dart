class BitwiseOperators {
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

class Bits {
  String name;
  final String _mask;
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

