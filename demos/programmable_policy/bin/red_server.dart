import 'package:programmable_policy/src/nodes/server_node/red_node.dart';

Future<int> main(List<String> args) async {
  return await RedNode().asMain(args);
}
