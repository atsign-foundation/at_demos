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
  // TODO: Instantiate variables
  //update
  String _key;
  String _value;

  // lookup
  TextEditingController _lookupTextFieldController = TextEditingController();
  String _lookupKey;
  String _lookupValue = '';

  // scan
  List<String> _scanItems = List<String>();

  // service
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

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
                        items: _scanItems.map((String key) {
                          return DropdownMenuItem(
                            value: key, //key != null ? key : null,
                            child: Text(key),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _lookupKey = value;
                            _lookupTextFieldController.text = value;
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
      // Intialize an AtKey object as pair
      AtKey pair = AtKey();
      // Defining the AtKey object attributes such as;
      // title (key), the current authenticated atsign
      pair.key = _key;
      pair.sharedWith = widget.atSign;
      // Utilizing the put method from the serverDemoService file,
      // we are passing the AtKey object and the data
      // (the text inputted by the user) alongside with it and simply
      // 'putting' it on the current authenticated atsign's secondary server
      await _serverDemoService.put(pair, _value);
    }
  }

  /// getAtKeys() will retrieve keys shared by [atSign].
  /// Strip any meta data away from the retrieves keys. Store
  /// the keys into [_scanItems].
  _scan() async {
    // Initialize a list of AtKey objects and populate this list with all of the
    // AtKey objects that already exist on the current authenticated atsign's
    // secondary server
    // Anything that the current authenticated atsign has already successfully
    // put on their server will be assigned an index in the list
    List<AtKey> response = await _serverDemoService.getAtKeys(
      sharedBy: widget.atSign,
    );
    // If there are any AtKey objects that are within the list intialized above
    if (response.length > 0) {
      // Initialize a list of strings that is populated with a map of AtKey
      // objects that have been converted to a list of values
      List<String> scanList = response.map((atKey) => atKey.key).toList();
      // setState is re-running the build method and displaying all of the
      // AtKey objects retrieved from the scan
      setState(() => _scanItems = scanList);
    }
  }

  /// Create instance of an AtKey and call get() on it.
  _lookup() async {
    if (_lookupKey != null) {
      // Initialize an AtKey object titled lookup
      AtKey lookup = AtKey();
      // Declare the attribute values such as its title (key) and the atsign
      // that created it
      lookup.key = _lookupKey;
      lookup.sharedWith = widget.atSign;
      // Initialize a string and populate it with an AtKey object
      // obtained from the serverDemoService's get method
      String response = await _serverDemoService.get(lookup);
      if (response != null) {
        // If an AtKey object exists, re-run the build method with the AtKey
        // object that was retrieved utilizing the get method
        setState(() => _lookupValue = response);
      }
    }
  }
}
