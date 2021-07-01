import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'add_dish_screen.dart';
import 'other_screen.dart';
import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/service/client_sdk_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';
  // final bool shouldReload;

  // const HomeScreen({
  //   this.shouldReload,
  // });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<DishWidget> sortedWidgets = [];
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String atSign = ClientSdkService.getInstance().getAtSign().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ' + ClientSdkService.getInstance().atsign!,
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
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'My Dishes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
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
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0XFF7B3F00),
        onPressed: () {
          Navigator.pushNamed(context, DishScreen.id)
              .then((value) => setState(() {}));
        },
      ),
    );
  }

  /// Scan for [AtKey] objects with the correct regex.
  _scan() async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    // Instantiate a list of AtKey objects to house each cached recipe from
    // the secondary server of the authenticated atsign
    List<AtKey> response;

    // This regex is defined for searching for an AtKey object that carries the
    // namespace of cookbook and that have been created by the authenticated
    // atsign (the currently logged in atsign)
    String regex = '^(?!cached).*cookbook.*';

    // Getting the recipes that are cached on the authenticated atsign's secondary
    // server utilizing the regex expression defined earlier
    response = await clientSdkService.getAtKeys(regex);
    response.retainWhere((element) => !element.metadata!.isCached);

    // Instantiating a list of strings
    List<String> responseList = [];

    // Looping through every instance of an AtKey object
    for (AtKey atKey in response) {
      // We get the current AtKey object that we are looping on
      String value = await _lookup(atKey);

      // In addition to the object we are on, we add the name of the recipe,
      // the constant splitter to segregate the fields, and again, the value of
      // the recipe which includes; description, ingredients, and image URL
      value = atKey.key! + constant.splitter + value;

      // Add current AtKey object to our list of strings defined earlier before
      // for loop
      responseList.add(value);
    }

    // After successfully looping through each AtKey object instance,
    // return list of strings
    return responseList;
  }

  /// Look up a value corresponding to an [AtKey] instance.
  Future<String> _lookup(AtKey atKey) async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    // If an AtKey object exists
    if (atKey != null) {
      // Simply get the AtKey object utilizing the serverDemoService's get method
      return await clientSdkService.get(atKey);
    }
    return '';
  }
}
