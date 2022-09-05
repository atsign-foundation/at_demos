import 'package:flutter/material.dart';

import '../../utils/texts.dart';

class ResetAppButton extends StatefulWidget {
  ResetAppButton({Key? key}) : super(key: key);

  @override
  State<ResetAppButton> createState() => _ResetAppButtonState();
}

class _ResetAppButtonState extends State<ResetAppButton> {
  bool? loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text(Texts.resetApp),
    );
  }

  // Future<void> _showResetDialog() async {
  //   bool isSelectAtsign = false;
  //   bool isSelectAll = false;
  // }
}
