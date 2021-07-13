import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:chefcookbook/service/client_sdk_service.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:core';

class OtherScreen extends StatelessWidget {
  static final String id = 'other';
  String? atSign = ClientSdkService.getInstance().atsign;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $atSign!',
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
    ClientSdkService clientSdkService = ClientSdkService.getInstance();

    //await ClientSdkService.getInstance().t_sync();
    // This regex is defined for searching for an AtKey object that carries the
    // namespace of cookbook from the authenticated atsign's secondary server
    // This regex is also specified to get any recipe that has been shared with
    // the currently authenticated atsign
    return await clientSdkService.getAtKeys('cached.*cookbook');
    // Took regex: 'cached.*cookbook' out of getatkeys
  }

  /// Returns a map of Shared recipes key and values.
  _getSharedRecipes() async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    // Instantiate a list of AtKey objects to store all of the retrieved
    // recipes that have been shared with the current authenticated atsign
    List<AtKey> sharedKeysList = await _getSharedKeys();

    // Instantiate a map for the recipes
    Map recipesMap = {};

    // Instantiate an AtKey object
    AtKey atKey = AtKey();

    // Specifying the isCached metadata attribute as true to cache the recipe
    // that was shared with the current authenticated atsign on its own
    // secondary server
    Metadata metadata = Metadata()..isCached = true;

    // Specifying the values (i.e. the description, ingredients, and image URL)
    // of each recipe in the list of recipes
    sharedKeysList.forEach((element) async {
      atKey
        ..key = element.key
        ..sharedWith = element.sharedWith
        ..sharedBy = element.sharedBy
        ..metadata = metadata;

      // Get the recipe
      String response = await clientSdkService.get(atKey);

      // Adds all key/value pairs of [other] to this map.
      // If a key of [other] is already in this map, its value is overwritten.
      // The operation is equivalent to doing `this[key] = value` for each key
      // and associated value in other. It iterates over [other], which must
      // therefore not change during the iteration.
      if (response != null)
        recipesMap.putIfAbsent('${element.key}', () => response);
    });
    // Return the entire map of shared recipes
    return recipesMap;
  }
}
