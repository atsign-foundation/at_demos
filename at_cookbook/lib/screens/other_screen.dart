import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:chefcookbook/service.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';
import 'package:at_client/at_client.dart';

class OtherScreen extends StatelessWidget {
  static final String id = 'other';
  final _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF1EBE5),
      appBar: AppBar(
        backgroundColor: Color(0XFF7B3F00),
        title: Text(
          'Welcome, ' + atSign,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder(
                future: _getSharedRecipes(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    // Returns a list of keys for each dish
                    Map dishAttributes = snapshot.data;
                    print(snapshot.data);
                    List<DishWidget> dishWidgets = [];
                    dishAttributes.forEach((key, value) {
                      var valueArr = value.split(constant.splitter);
                      dishWidgets.add(DishWidget(
                          title: key,
                          description: valueArr[0],
                          ingredients: valueArr[1],
                          imageURL: valueArr[2]));
                    });
                    return SafeArea(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreen.id);
                                },
                              ),
                              Text(
                                'Shared Dishes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.black87,
                                ),
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
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the list of Shared Receipes keys
  _getSharedKeys() async {
    await _serverDemoService.sync();
    return await _serverDemoService.getAtKeys(regex: 'cached.*cookbook');
  }

  /// Returns a map of Shared recipes key and values
  _getSharedRecipes() async {
    List<AtKey> sharedKeysList = await _getSharedKeys();
    var recipesMap = {};
    var atKey = AtKey();
    var metadata = Metadata()..isCached = true;
    sharedKeysList.forEach((element) async {
      atKey
        ..key = element.key
        ..sharedWith = element.sharedWith
        ..sharedBy = element.sharedBy
        ..metadata = metadata;
      var response = await _serverDemoService.get(atKey);
      recipesMap.putIfAbsent('${element.key}', () => response);
    });
    return recipesMap;
  }
}
