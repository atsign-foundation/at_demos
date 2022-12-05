import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_cookbook_refactored/dish_widget.dart';
import 'add_dish_screen.dart';
import 'other_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<DishWidget> sortedWidgets = <DishWidget>[];

  String atSign =
      AtClientManager.getInstance().atClient.getCurrentAtSign().toString();

  final String splitter = '@@';

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
                      List<String> attributesList = attributes.split(splitter);
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => OtherScreen()));
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
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DishScreen()));
        },
      ),
    );
  }

  Future<List<String>> _scan() async {
    List<AtKey> response;

    //TODO: Create valid regex argument to get just namespace of app
    //String regex = '^(?!cached).*at_cookbook_refactored.*';
    String regex = ".*";
    response =
        await AtClientManager.getInstance().atClient.getAtKeys(regex: regex);
    //     await AtClientManager.getInstance().atClient.getAtKeys(regex: regex);
    // response.retainWhere((AtKey element) => !element.metadata!.isCached);

    List<String> responseList = <String>[];

    for (AtKey atKey in response) {
      if (formatAtsign(atKey.sharedWith) !=
          formatAtsign(
              AtClientManager.getInstance().atClient.getCurrentAtSign())) {
        continue;
      }
      try {
        String value = (await _lookup(atKey)).value;
        value = atKey.key! + splitter + (value ?? '');

        responseList.add(value);
      } catch (e) {}
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
