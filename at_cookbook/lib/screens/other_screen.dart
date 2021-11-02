import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:core';
import 'package:at_client/src/service/notification_service.dart';

class OtherScreen extends StatefulWidget {
  static final String id = 'other';

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  final String? atSign =
      AtClientManager.getInstance().atClient.getCurrentAtSign();

  late Future future;
  // Instantiate a map for the recipes

  void _notificationCallback(AtNotification notification) async {
    if (notification.operation == "update") {
      setState(() {
        future = _getSharedRecipes();
      });
    }
  }

  @override
  void initState() {
    setState(() {
      future = _getSharedRecipes();
    });

    /// Listen to notifications.
    NotificationService notificationService =
        AtClientManager.getInstance().notificationService;
    notificationService.subscribe().listen((notification) {
      _notificationCallback(notification);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $atSign!',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<Map<String?, String>>(
                  future: _getSharedRecipes(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      // Returns a map that has a dish's title as its key and
                      // a dish's attributes for its value.
                      Map<String?, String?> dishAttributes = snapshot.data;
                      print(snapshot.data);
                      List<DishWidget> dishWidgets = <DishWidget>[];
                      dishAttributes.forEach((String? key, String? value) {
                        List<String> valueArr = value!.split(constant.splitter);
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: <Widget>[
                                IconButton(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_left,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.id);
                                  },
                                ),
                                const Text(
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
                      return const Center(child: CircularProgressIndicator());
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
  Future<List<AtKey>> _getSharedKeys() async {
    //AtClientManager clientSdkService = ClientSdkService.getInstance();

    //await ClientSdkService.getInstance().t_sync();
    // This regex is defined for searching for an AtKey object that carries the
    // namespace of cookbook from the authenticated atsign's secondary server
    // This regex is also specified to get any recipe that has been shared with
    // the currently authenticated atsign
    return AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: 'cached.*cookbook');
    // Took regex: 'cached.*cookbook' out of getatkeys
  }

  /// Returns a map of Shared recipes key and values.
  Future<Map<String?, String>> _getSharedRecipes() async {
    Map<String?, String> recipesMap = <String?, String>{};
    // ClientSdkService clientSdkService = ClientSdkService.getInstance();
    // Instantiate a list of AtKey objects to store all of the retrieved
    // recipes that have been shared with the current authenticated atsign
    List<AtKey> sharedKeysList = await _getSharedKeys();

    // Instantiate an AtKey object
    AtKey atKey = AtKey();

    // Specifying the isCached metadata attribute as true to cache the recipe
    // that was shared with the current authenticated atsign on its own
    // secondary server
    Metadata metadata = Metadata()..isCached = true;

    // Specifying the values (i.e. the description, ingredients, and image URL)
    // of each recipe in the list of recipes
    for (AtKey element in sharedKeysList) {
      atKey
        ..key = element.key
        ..sharedWith = element.sharedWith
        ..sharedBy = element.sharedBy
        ..metadata = metadata;

      // Get the recipe
      String? response =
          (await AtClientManager.getInstance().atClient.get(atKey)).value;

      // Adds all key/value pairs of [other] to this map.
      // If a key of [other] is already in this map, its value is overwritten.
      // The operation is equivalent to doing `this[key] = value` for each key
      // and associated value in other. It iterates over [other], which must
      // therefore not change during the iteration.
      if (response != null) {
        recipesMap.putIfAbsent(element.key, () => response);
      }
    }
    // Return the entire map of shared recipes
    return recipesMap;
  }
}
