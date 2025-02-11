import 'package:flutter/material.dart';
import 'package:programmable_policy/src/app/logs_page.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network graph"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LogsPage()),
            ),
            child: const Text("Show logs"),
          )
        ],
      ),
      body: Container(),
    );
  }
}
