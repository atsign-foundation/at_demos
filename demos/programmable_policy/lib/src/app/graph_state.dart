enum NodeType {
  client,
  server,
  agent,
}

enum LineType {
  allowed,
  active,
}

class Node {}

class GraphState {
  final Stream<String> events;
  GraphState(this.events) {
    handleStream();
  }

  void handleStream() {
    // TODO
  }
}
