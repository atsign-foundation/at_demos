import 'package:programmable_policy/src/server_node/yellow_node.dart';

Future<int> main(List<String> args) async {
  return await YellowNode().asMain(args);
}
