import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/service.dart';
import 'package:flutter/cupertino.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';
import 'share_screen.dart';
import 'package:flutter/material.dart';

class DishPage extends StatelessWidget {
  final DishWidget? dishWidget;
  final _serverDemoService = ServerDemoService.getInstance();

  DishPage({@required this.dishWidget});

  List<Text> convertStringsToWidgets(List<dynamic> ingredients) {
    List<Text> ingredientList = [];
    for (dynamic ingredient in ingredients) {
      ingredientList.add(
        Text(
          ingredient.toString(),
        ),
      );
    }
    return ingredientList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dishWidget!.title!,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white70,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                dishWidget!.title!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundImage: dishWidget!.imageURL == null
                                    ? const AssetImage('assets/question_mark.png')
                                    : NetworkImage(dishWidget!.imageURL!)
                                        as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Divider(
                            color: Colors.black87,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              dishWidget!.description!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ingredients: ' + dishWidget!.ingredients!,
                              style: const TextStyle(
                                color: Color(0xff7b3f00),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            dishWidget!.prevScreen == HomeScreen.id
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RoundedButton(
                        path: () {
                          _delete(context);
                        },
                        text: 'Remove',
                        width: 180,
                        color: Colors.redAccent,
                      ),
                      RoundedButton(
                        path: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShareScreen(dishWidget: dishWidget)),
                          );
                        },
                        text: 'Share',
                        width: 180,
                        color: const Color(0xff7b3f00),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  /// Deletes a key/value pair in the secondary server of
  /// the logged-in @sign.
  Future<void> _delete(BuildContext context) async {
    //TODO: implement _delete func
    if (dishWidget!.title != null) {
      AtKey atKey = AtKey();
      atKey.key = dishWidget!.title;
      atKey.sharedWith = atSign;
      await _serverDemoService.delete(atKey);
    }
    await Navigator.of(context).pushNamedAndRemoveUntil(
        dishWidget!.prevScreen!, (Route<dynamic> route) => false,
        arguments: true);
  }
}
