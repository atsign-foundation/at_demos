import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:at_commons/at_commons.dart';
import '../service/client_sdk_service.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? atSign;
  String? _key;
  String? _value;

  // lookup
  final TextEditingController? _lookupTextFieldController = TextEditingController();
  String? _lookupKey;
  String? _lookupValue;

  // scan
  List<String?> _scanItems = <String>[];

  // service
  final ClientSdkService _serverDemoService = ClientSdkService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //update
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.create, size: 70),
                      title: const Text(
                        'Update ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          TextField(
                            decoration: const InputDecoration(hintText: 'Enter Key'),
                            onChanged: (String key) {
                              _key = key;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter Value',
                            ),
                            onChanged: (String value) {
                              _value = value;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        onPressed: _update,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //scan
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.scanner, size: 70),
                      title: const Text(
                        'Scan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: DropdownButton<String>(
                        hint: const Text('Select Key'),
                        items: _scanItems.map((String? key) {
                          return DropdownMenuItem<String>(
                            value: key, //key != null ? key : null,
                            child: Text(key!),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _lookupKey = value;
                            _lookupTextFieldController!.text = value!;
                          });
                        },
                        value: _scanItems.isNotEmpty
                            ? _lookupTextFieldController!.text.isEmpty
                                ? _scanItems[0]
                                : _lookupTextFieldController!.text
                            : '',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextButton(
                        child: const Text(
                          'Scan',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(backgroundColor: Colors.deepOrange),
                        onPressed: _scan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //lookup
            Flexible(
              fit: FlexFit.loose,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.list, size: 70),
                      title: const Text(
                        'LookUp',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            decoration: const InputDecoration(hintText: 'Enter Key'),
                            controller: _lookupTextFieldController,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Lookup Result : ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _lookupValue ?? '',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextButton(
                        child: const Text(
                          'Lookup',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(backgroundColor: Colors.deepOrange),
                        onPressed: _lookup,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Create instance of an AtKey and pass that
  /// into the put() method with the corresponding
  /// _value string.
  Future<void> _update() async {
    if (_key != null && _value != null) {
      AtKey pair = AtKey();
      pair.key = _key;
      pair.sharedWith = atSign;
      await _serverDemoService.put(pair, _value!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${pair.key} value updated',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  /// getAtKeys() will retrieve keys shared by [widget.atSign].
  /// Strip any meta data away from the retrieves keys. Store
  /// the keys into [_scanItems].
  Future<void> _scan() async {
    List<AtKey> response = await _serverDemoService.getAtKeys(
      sharedBy: atSign,
    );
    if (response.isNotEmpty) {
      List<String?> scanList = response.map((AtKey atKey) => atKey.key).toList();
      setState(() => _scanItems = scanList);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Scanning keys and values done.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Create instance of an AtKey and call get() on it.
  Future<void> _lookup() async {
    if (_lookupKey == null) {
      setState(() => _lookupValue = 'The key is empty.');
    } else {
      AtKey lookup = AtKey();
      lookup.key = _lookupKey;
      lookup.sharedWith = atSign;
      String? response = await _serverDemoService.get(lookup);
      setState(() => _lookupValue = response);
    }
  }
}
