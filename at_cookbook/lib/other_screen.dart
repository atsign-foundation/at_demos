import 'dart:core';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_cookbook_refactored/dish_widget.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:at_client/src/service/sync_service.dart';

class OtherScreen extends StatefulWidget {
  static final String id = 'other';

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  final String splitter = '@@';
  final String? atSign =
      AtClientManager.getInstance().atClient.getCurrentAtSign();

  late Future<Map<String?, String>> future;

  void _syncCallback() async {
    setState(() {
      future = _getSharedRecipes();
    });
  }

  @override
  void initState() {
    setState(() {
      future = _getSharedRecipes();
    });

    SyncService syncService = AtClientManager.getInstance().syncService;
    syncService.setOnDone(_syncCallback);
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
                  future: future,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      Map<String?, String?> dishAttributes = snapshot.data;
                      print(snapshot.data);
                      List<DishWidget> dishWidgets = <DishWidget>[];
                      dishAttributes.forEach((String? key, String? value) {
                        List<String> valueArr = value!.split(splitter);
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeScreen()));
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

  Future<List<AtKey>> _getSharedKeys() async {
    return AtClientManager.getInstance()
        .atClient
        .getAtKeys(regex: 'cached.*cookbook');
  }

  Future<Map<String?, String>> _getSharedRecipes() async {
    Map<String?, String> recipesMap = <String?, String>{};

    List<AtKey> sharedKeysList = await _getSharedKeys();

    AtKey atKey = AtKey();

    Metadata metadata = Metadata()..isCached = true;

    for (AtKey element in sharedKeysList) {
      atKey
        ..key = element.key
        ..sharedWith = element.sharedWith
        ..sharedBy = element.sharedBy
        ..metadata = metadata;

      String? response =
          (await AtClientManager.getInstance().atClient.get(atKey)).value;

      if (response != null) {
        recipesMap.putIfAbsent(element.key, () => response);
      }
    }
    return recipesMap;
  }
}
