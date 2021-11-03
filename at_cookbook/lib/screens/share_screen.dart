import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  static final String id = 'share';
  final DishWidget? dishWidget;

  ShareScreen({@required this.dishWidget});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String? _otherAtSign;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF7B3F00),
        title: const Text('Add a dish'),
      ),
      backgroundColor: const Color(0XFFF1EBE5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'choice chef',
                      child: SizedBox(
                        height: 200,
                        child: Image.asset(
                          'assets/chef.png',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Enter an @sign to chat with'),
                    onChanged: (String value) {
                      _otherAtSign = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                    text: 'Share Cuisine',
                    color: const Color(0XFF7B3F00),
                    path: () async => _share(context, _otherAtSign!),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, String? sharedWith) async {
    if (sharedWith != null) {
      String? atSign =
          AtClientManager.getInstance().atClient.getCurrentAtSign();
      AtKey lookup = AtKey()
        ..key = widget.dishWidget!.title
        ..sharedWith = atSign;

      String value =
          (await AtClientManager.getInstance().atClient.get(lookup)).value;

      Metadata metadata = Metadata()..ttr = 1;

      AtKey atKey = AtKey()
        ..key = widget.dishWidget!.title
        ..metadata = metadata
        ..sharedBy = atSign
        ..sharedWith = sharedWith;

      await AtClientManager.getInstance().atClient.put(atKey, value);
      Navigator.pop(context);
    }
  }
}
