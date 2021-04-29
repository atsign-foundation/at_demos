import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:chefcookbook/service.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';

class OtherScreen extends StatelessWidget {
  static final String id = 'other';
  final _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      // Returns a map that has a dish's title as its key and
                      // a dish's attributes for its value.
                      Map dishAttributes = snapshot.data;
                      print(snapshot.data);
                      List<DishWidget> dishWidgets = [];
                      dishAttributes.forEach((key, value) {
                        List<String> valueArr = value.split(constant.splitter);
                        dishWidgets.add(
                          DishWidget(
                            title: key,
                            description: valueArr[0],
                            ingredients: valueArr[1],
                            imageURL: valueArr.length == 3 ? valueArr[2] : null,
                            prevScreen: OtherScreen.id,
                          ),
                        );
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
                      return Text('An error has occurred: ' +
                          snapshot.error.toString());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the list of Shared Recipes keys.
  _getSharedKeys() async {
    //TODO: _getSharedKeys func
    await _serverDemoService.sync();
    return await _serverDemoService.getAtKeys(regex: 'cached.*cookbook');
  }

  /// Returns a map of Shared recipes key and values.
  _getSharedRecipes() async {
    //TODO: implement _getSharedRecipes() func
    List<AtKey> sharedKeysList = await _getSharedKeys();
    Map recipesMap = {};
    AtKey atKey = AtKey();
    Metadata metadata = Metadata()..isCached = true;
    sharedKeysList.forEach((element) async {
      atKey.key = element.key;
      atKey.sharedWith = element.sharedWith;
      atKey.sharedBy = element.sharedBy;
      atKey.metadata = metadata;
      String response = await _serverDemoService.get(atKey);
      recipesMap.putIfAbsent('${element.key}', () => response);
    });
    return recipesMap;
  }
}
