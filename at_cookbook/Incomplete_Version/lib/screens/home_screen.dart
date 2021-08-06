import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'add_dish_screen.dart';
import 'other_screen.dart';
import 'welcome_screen.dart';
import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';
  final bool? shouldReload;

  const HomeScreen({
    this.shouldReload,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<DishWidget> sortedWidgets = [];
  final ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  void checkReload() {
    if (widget.shouldReload!) {
      setState(() {});
    }
  }

  @override
  void initState() {
    checkReload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ' + atSign!,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder(
                future: _scan(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    // Returns a list of attributes for each dish.
                    List<String> dishAttributes = snapshot.data;
                    print(snapshot.data);
                    List<DishWidget> dishWidgets = [];
                    for (String attributes in dishAttributes) {
                      // Populate a DishWidget based on the attributes string.
                      List<String> attributesList =
                          attributes.split(constant.splitter);
                      if (attributesList.length >= 3) {
                        DishWidget dishWidget = DishWidget(
                          title: attributesList[0],
                          description: attributesList[1],
                          ingredients: attributesList[2],
                          imageURL: attributesList.length == 4
                              ? attributesList[3]
                              : null,
                          prevScreen: HomeScreen.id,
                        );
                        dishWidgets.add(dishWidget);
                      }
                    }
                    return SafeArea(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'My Dishes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_right,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, OtherScreen.id);
                                    },
                                  )
                                ]),
                          ),
                          Column(
                            children: dishWidgets,
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'An error has occurred: ' + snapshot.error.toString());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7b3f00),
        onPressed: () {
          Navigator.pushNamed(context, DishScreen.id)
              .then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Scan for [AtKey] objects with the correct regex.
  Future<List<String>>_scan() async {
    List<AtKey> response;
    String regex = '^(?!cached).*cookbook.*';
    response = await _serverDemoService.getAtKeys(regex: regex);
    List<String> responseList = [];
    for (AtKey atKey in response) {
      String? value = await _lookup(atKey);
      value = atKey.key! + constant.splitter + value!;
      responseList.add(value);
    }
    return responseList;
  }

  /// Look up a value corresponding to an [AtKey] instance.
  Future<String?> _lookup(AtKey? atKey) async {
    return _serverDemoService.get(atKey!);
  }
}
