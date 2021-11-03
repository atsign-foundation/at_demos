import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:chefcookbook/constants.dart';
import 'add_dish_screen.dart';
import 'other_screen.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<DishWidget> sortedWidgets = <DishWidget>[];

  String atSign =
      AtClientManager.getInstance().atClient.getCurrentAtSign().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ' +
              AtClientManager.getInstance().atClient.getCurrentAtSign()!,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder<List<String>>(
                future: _scan(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    List<String> dishAttributes = snapshot.data;
                    print(snapshot.data);
                    List<DishWidget> dishWidgets = <DishWidget>[];
                    for (String attributes in dishAttributes) {
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
        child: const Icon(Icons.add),
        backgroundColor: const Color(0XFF7B3F00),
        onPressed: () async {
          Navigator.pushNamed(context, DishScreen.id)
              .then((Object? value) => setState(() {}));
        },
      ),
    );
  }

  Future<List<String>> _scan() async {
    List<AtKey> response;

    response =
        await AtClientManager.getInstance().atClient.getAtKeys(regex: regex);
    response.retainWhere((AtKey element) => !element.metadata!.isCached);

    List<String> responseList = <String>[];

    for (AtKey atKey in response) {
      if (formatAtsign(atKey.sharedWith) !=
          formatAtsign(
              AtClientManager.getInstance().atClient.getCurrentAtSign())) {
        continue;
      }

      String? value = (await _lookup(atKey)).value;

      value = atKey.key! + constant.splitter + (value ?? "");

      responseList.add(value);
    }

    return responseList;
  }

  Future<dynamic> _lookup(AtKey? atKey) async {
    if (atKey != null) {
      return AtClientManager.getInstance().atClient.get(atKey);
    }
    return null;
  }

  String? formatAtsign(String? atSign) {
    return atSign?.trim().replaceFirst("@", "");
  }
}
