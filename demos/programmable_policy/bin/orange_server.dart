import 'package:programmable_policy/src/server_node/orange_node.dart';

Future<int> main(List<String> args) async {
  return await OrangeNode().asMain(args);
}
