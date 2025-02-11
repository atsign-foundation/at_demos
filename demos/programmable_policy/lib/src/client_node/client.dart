Map<String, ColorClient> clients = {
  // "blue": BlueClient(),
};

class Client {
  final List<String> colors;
  Client(this.colors);
  // TODOO implement me
}

// Class which contains color specific code for each client
abstract class ColorClient {}
