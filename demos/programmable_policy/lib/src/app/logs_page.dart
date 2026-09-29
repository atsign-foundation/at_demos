import 'package:flutter/material.dart';
import 'package:programmable_policy/src/app/logs_state.dart';

class LogsPage extends StatefulWidget {
  final LogsState logsState;

  const LogsPage(this.logsState, {super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String? filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logs")),
      body: Row(children: [
        SizedBox(
          width: 200,
          child: StreamBuilder(
            initialData: widget.logsState.atSigns.length,
            stream: widget.logsState.atSignsSize,
            builder: (context, size) {
              if (size.hasData) {
                return ListView.builder(
                  itemCount: size.data! + 1,
                  itemBuilder: (context, idx) {
                    return TextButton(
                      onPressed: () {
                        if (idx == 0) {
                          setState(() {
                            filter = null;
                          });
                          return;
                        }
                        setState(() {
                          filter = widget.logsState.atSigns[idx - 1];
                        });
                      },
                      child: idx == 0 ? Text("Show All") : Text(widget.logsState.atSigns[idx - 1]),
                    );
                  },
                );
              }
              if (size.hasError) {
                return Text("Error: ${size.error.toString()}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        LogsViewPort(logsState: widget.logsState, filter: filter),
      ]),
    );
  }
}

class LogsViewPort extends StatelessWidget {
  final LogsState logsState;
  final String? filter;
  const LogsViewPort({required this.logsState, this.filter, super.key});

  @override
  Widget build(BuildContext context) {
    if (filter == null) {
      return ListView.builder(
        itemCount: logsState.logs.length,
        itemBuilder: (context, idx) {
          var record = logsState.logs[idx];
          return Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(record.$1),
              ),
              Text(record.$2),
            ],
          );
        },
      );
    }
    var logs = logsState.filtered(filter!);
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, idx) {
        var record = logs[idx];
        return Row(
          children: [
            Text(record),
          ],
        );
      },
    );
  }
}
