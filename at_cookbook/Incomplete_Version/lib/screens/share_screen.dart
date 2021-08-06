import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import '../service.dart';

class ShareScreen extends StatefulWidget {
  static final String id = 'share';
  final DishWidget? dishWidget;

  ShareScreen({@required this.dishWidget});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String? _otherAtSign;
  List<String>? _atSigns;
  final ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  void initList() {
    List<String> otherAtSigns = at_demo_data.allAtsigns;
    otherAtSigns.remove(atSign);
    setState(() {
      _atSigns = otherAtSigns;
    });
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7b3f00),
        title: const Text('Add a dish'),
      ),
      backgroundColor: const Color(0xfff1ebe5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                  ListTile(
                    title: Center(
                      child: DropdownButton<String>(
                        hint: const Text('\tPick an @sign'),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        iconSize: 24,
                        dropdownColor: const Color(0xfff1ebe5),
                        elevation: 16,
                        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
                        onChanged: (String? newValue) {
                          setState(() {
                            _otherAtSign = newValue;
                          });
                        },
                        value: _otherAtSign,
                        items: _atSigns == null
                            ? []
                            : _atSigns!
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                    text: 'Share Cuisine',
                    color: const Color(0xff7b3f00),
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
    //TODO: implement the _share func
    if (sharedWith != null) {
      AtKey lookup = AtKey();
      lookup.key = widget.dishWidget!.title;
      lookup.sharedWith = atSign;
      String value = await _serverDemoService.get(lookup);
      var metadata = Metadata()..ttr = -1;
      AtKey atKey = AtKey();
      atKey.key = widget.dishWidget!.title;
      atKey.metadata = metadata;
      atKey.sharedBy = atSign;
      atKey.sharedWith = _otherAtSign;
      var operation = OperationEnum.update;
      await _serverDemoService.notify(atKey, value, operation);
    }
  }
}
