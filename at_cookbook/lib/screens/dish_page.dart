import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/service.dart';
import 'package:flutter/cupertino.dart';
import 'welcome_screen.dart';
import 'package:flutter/material.dart';

class DishPage extends StatelessWidget {
  final DishWidget dishWidget;
  final _serverDemoService = ServerDemoService.getInstance();

  DishPage({@required this.dishWidget});

  convertStringsToWidgets(List<dynamic> ingredients) {
    List<Text> ingredientList = [];
    for (dynamic ingredient in ingredients) {
      ingredientList.add(Text((ingredient.toString())));
    }
    return ingredientList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF7B3F00),
        title: Text(
          dishWidget.title,
        ),
      ),
      backgroundColor: Color(0XFFF1EBE5),
      body: SafeArea(
        child: Column(
          children: <Widget> [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white70,
                  child: Center(
                    child: Column(
                      children: <Widget> [
                        Row(
                          children: <Widget> [
                            Expanded(
                              child: Text(
                                dishWidget.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundImage: NetworkImage(
                                  dishWidget.imageURL,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Divider(
                            color: Colors.black87,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  dishWidget.description,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ingredients: ' + dishWidget.ingredients,
                              style: TextStyle(
                                color: Color(0XFF7B3F00),
                                fontSize: 18,
                              ),
                            )
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: RoundedButton(
                path: () {
                  _delete(context);
                },
                text: 'Remove',
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Work in progress. Currently, you need to hot reload
  // the home screen for the dish to disappear.
  _delete(BuildContext context) async {
    if (dishWidget.title != null) {
      AtKey atKey = AtKey();
      atKey.key = dishWidget.title;
      atKey.sharedWith = atSign;
      await _serverDemoService.delete(atKey);
    }
    Navigator.pop(context);
  }
}

