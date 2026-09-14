import 'package:flutter/material.dart';
import 'package:programmable_policy/src/app/graph_state.dart';

class GraphPage extends StatelessWidget {
  final GraphState graphState;
  const GraphPage(this.graphState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-time Graph"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('logs'),
            child: const Text("Show logs"),
          )
        ],
      ),
      body: Container(),
    );
  }
}
