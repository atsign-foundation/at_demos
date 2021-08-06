import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:at_commons/at_commons.dart';
import 'package:newserverdemo/services/server_demo_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';

  final String atSign;

  const HomeScreen({
    Key key,
    @required this.atSign,
  })  : assert(atSign != null),
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //update
  String _key;
  String _value;

  // lookup
  final TextEditingController _lookupTextFieldController =
      TextEditingController();
  String _lookupKey;
  String _lookupValue = '';

  // scan
  List<String> _scanItems = <String>[];

  // service
  final ServerDemoService _serverDemoService = ServerDemoService.getInstance();

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
          children: [
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
                        children: [
                          TextField(
                            decoration:
                                const InputDecoration(hintText: 'Enter Key'),
                            onChanged: (key) {
                              _key = key;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter Value',
                            ),
                            onChanged: (value) {
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
                        items: _scanItems.map((String key) {
                          return DropdownMenuItem(
                            value: key,
                            child: Text(key),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _lookupKey = value;
                            _lookupTextFieldController.text = value;
                          });
                        },
                        value: _scanItems.isNotEmpty ? _scanItems[0] : '',
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
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            // ignore: prefer_const_constructors
                            decoration: InputDecoration(hintText: 'Enter Key'),
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
                            _lookupValue,
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
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange),
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

  // TODO: add the _scan, _update, and _lookup methods
  Future<void> _update() async {
    if (_key != null && _value != null) {
      AtKey pair = AtKey();
      pair.key = _key;
      pair.sharedWith = widget.atSign;
      await _serverDemoService.put(pair, _value);
    }
  }

  Future<void>  _scan() async {
    List<AtKey> response = await _serverDemoService.getAtKeys(
      sharedBy: widget.atSign,
    );
    if (response.isNotEmpty) {
      List<String> scanList = response.map((atKey) => atKey.key).toList();
      setState(() => _scanItems = scanList);
    }
  }

  Future<void> _lookup() async {
    if (_lookupKey != null) {
      AtKey lookup = AtKey();
      lookup.key = _lookupKey;
      lookup.sharedWith = widget.atSign;
      String response = await _serverDemoService.get(lookup);
      if (response != null) {
        setState(() => _lookupValue = response);
      }
    }
  }
}
