import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programmable_policy/src/app/graph_state.dart';
import 'package:programmable_policy/src/app/logs_state.dart';
import 'package:programmable_policy/src/worker/worker.dart';

import 'login_page.dart';
import 'logs_page.dart';
import 'graph_page.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

void log(Object? o) {
  // ignore: avoid_print
  print(o);
}

class _AppState extends State<App> {
  // Setup during initialization
  late final Worker<String> policyWorker;
  late final Worker<String> simulationWorker;
  late final GraphState graphState;
  late final LogsState logsState;

  final Completer<bool> initialized = Completer();

  final StreamController<String> graphEvents = StreamController();
  final StreamController<String> logsEvents = StreamController();

  @override
  void initState() {
    super.initState();
    log("hello");
    _init();
  }

  void _init() async {
    log('spawning policy worker');
    policyWorker = await spawnWorker<String>('policy');
    log('spawning simulation worker');
    simulationWorker = await spawnWorker<String>('simulation');

    // These streams sort messages from the two workers to hand off to the
    // correct pages

    log('setting up policy event sorter');
    policyWorker.events.listen((event) {
      if (event.startsWith('graph')) {
        graphEvents.add(event);
      } else if (event.startsWith('logs')) {
        logsEvents.add(event);
      }
    });

    log('setting up simulation event sorter');
    simulationWorker.events.listen((event) {
      if (event.startsWith('graph')) {
        graphEvents.add(event);
      } else if (event.startsWith('logs')) {
        logsEvents.add(event);
      }
    });

    log('setting up graph state handler');
    graphState = GraphState(graphEvents.stream);

    log('setting up log state handler');
    logsState = LogsState(logsEvents.stream);
    initialized.complete(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programmable Policy Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: 'login',
      routes: {
        'login': (ctx) => wrappedInitalization(ctx, (_) => LoginPage(policyWorker: policyWorker)),
        'graph': (ctx) => wrappedInitalization(ctx, (_) => GraphPage(graphState)),
        'logs': (ctx) => wrappedInitalization(ctx, (_) => LogsPage(logsState)),
      },
    );
  }

  Widget wrappedInitalization(BuildContext context, Widget Function(BuildContext) builder) {
    return FutureBuilder(
      future: initialized.future,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data as bool) {
          return builder(context);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
