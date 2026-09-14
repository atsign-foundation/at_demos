import 'package:programmable_policy/src/nodes/server_node/green_node.dart';

Future<int> main(List<String> args) async {
  return await GreenNode().asMain(args);
}
