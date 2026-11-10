import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:programmable_policy/src/worker/worker.dart';

class LoginPage extends StatefulWidget {
  final Worker<String> policyWorker;
  const LoginPage({required this.policyWorker, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController atSignController = TextEditingController();
  String? atKeysFile;
  String? storageDirectory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(children: [
          const Text("atSign:"),
          TextField(controller: atSignController),
        ]),
        Row(children: [
          Text("atKeys file: $atKeysFile"),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? res = await FilePicker.platform.pickFiles();
              if (res != null && res.paths.isNotEmpty) {
                setState(() {
                  atKeysFile = res.paths.first;
                });
              }
            },
            child: const Text("Pick"),
          ),
        ]),
        Row(children: [
          Text("Storage directory: $storageDirectory"),
          ElevatedButton(
            onPressed: () async {
              String? res = await FilePicker.platform.getDirectoryPath();
              if (res != null) {
                setState(() {
                  storageDirectory = res;
                });
              }
            },
            child: const Text("Pick"),
          ),
        ]),
        ElevatedButton(
          onPressed: atKeysFile != null && storageDirectory != null && atSignController.text.isNotEmpty
              ? () {
                  var payload = jsonEncode({
                    "atSign": atSignController.text,
                    "atKeysFile": atKeysFile!,
                    "storageDir": storageDirectory!,
                  });
                  widget.policyWorker.send("login:$payload");
                  Navigator.of(context).pushReplacementNamed("graph");
                }
              : null,
          child: const Text("Submit"),
        ),
      ]),
    );
  }
}
