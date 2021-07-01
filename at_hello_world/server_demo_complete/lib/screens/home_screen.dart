import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:at_commons/at_commons.dart';
import '../utils/constants.dart';
import '../service/client_sdk_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';

  String? atSign;

  // const HomeScreen({
  //   Key key,
  //   @required this.atSign,
  // })  : assert(atSign != null),
  //       super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: Instantiate variables
  //update
  String? _key;
  String? _value;

  // lookup
  TextEditingController _lookupTextFieldController = TextEditingController();
  String? _lookupKey;
  String _lookupValue = '';

  // scan
  List<String?> _scanItems = [];

  // service
  ClientSdkService _serverDemoService = ClientSdkService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      leading: Icon(Icons.create, size: 70),
                      title: Text(
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
                            decoration: InputDecoration(hintText: 'Enter Key'),
                            // TODO: Assign the key
                            onChanged: (key) {
                              _key = key;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Value',
                            ),
                            // TODO: Assign the value
                            onChanged: (value) {
                              _value = value;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text('Update'),
                        color: Colors.deepOrange,
                        textColor: Colors.white,
                        // TODO: Complete the onPressed function
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
                      leading: Icon(Icons.scanner, size: 70),
                      title: Text(
                        'Scan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: DropdownButton<String>(
                        hint: Text('Select Key'),
                        // TODO: complete these parameters
                        items: _scanItems.map((String? key) {
                          return DropdownMenuItem(
                            value: key, //key != null ? key : null,
                            child: Text(key!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _lookupKey = value;
                            _lookupTextFieldController.text = value!;
                          });
                        },
                        value: _scanItems.length > 0 ? _scanItems[0] : '',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: FlatButton(
                        child: Text('Scan'),
                        color: Colors.deepOrange,
                        textColor: Colors.white,
                        // TODO: Complete the onPressed function
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
                      leading: Icon(Icons.list, size: 70),
                      title: Text(
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
                        children: [
                          TextField(
                            decoration: InputDecoration(hintText: 'Enter Key'),
                            // TODO: Assign the controller
                            controller: _lookupTextFieldController,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Lookup Result : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          // TODO: assign a String to the Text widget
                          Text(
                            '$_lookupValue',
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: FlatButton(
                        child: Text('Lookup'),
                        color: Colors.deepOrange,
                        textColor: Colors.white,
                        // TODO: complete the onPressed function
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
  /// Create instance of an AtKey and pass that
  /// into the put() method with the corresponding
  /// _value string.
  _update() async {
    if (_key != null && _value != null) {
      AtKey pair = AtKey();
      pair.key = _key;
      pair.sharedWith = widget.atSign;
      await _serverDemoService.put(pair, _value!);
    }
  }

  /// getAtKeys() will retrieve keys shared by [atSign].
  /// Strip any meta data away from the retrieves keys. Store
  /// the keys into [_scanItems].
  _scan() async {
    List<AtKey> response = await _serverDemoService.getAtKeys(
      sharedBy: widget.atSign!,
    );
    if (response.length > 0) {
      List<String?> scanList = response.map((atKey) => atKey.key).toList();
      setState(() => _scanItems = scanList);
    }
  }

  /// Create instance of an AtKey and call get() on it.
  _lookup() async {
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
