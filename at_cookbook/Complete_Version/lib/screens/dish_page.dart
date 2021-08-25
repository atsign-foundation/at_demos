import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:chefcookbook/service/client_sdk_service.dart';
import 'package:flutter/cupertino.dart';
import 'home_screen.dart';
import 'share_screen.dart';
import 'package:flutter/material.dart';

class DishPage extends StatelessWidget {
  final DishWidget? dishWidget;
  final ClientSdkService clientSdkService = ClientSdkService.getInstance();

  DishPage({@required this.dishWidget});

  List<Text> convertStringsToWidgets(List<dynamic> ingredients) {
    List<Text> ingredientList = <Text>[];
    for (dynamic ingredient in ingredients) {
      ingredientList.add(Text((ingredient.toString())));
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
                                    : NetworkImage(dishWidget!.imageURL!) as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                                color: Color(0XFF7B3F00),
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
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => ShareScreen(dishWidget: dishWidget),
                            ),
                          );
                        },
                        text: 'Share',
                        width: 180,
                        color: const Color(0XFF7B3F00),
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
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    String? atSign = await clientSdkService.getAtSign();
    // If the recipe has a name
    if (dishWidget!.title != null) {
      // Instantiate an AtKey object and specify its attributes by passing
      // the name of the recipe and the authenticated atsign
      AtKey atKey = AtKey();
      atKey.key = dishWidget!.title;
      atKey.sharedWith = atSign;

      // Utilizing the delete method, after passing the recipe, the object
      // cached on the secondary server will be deleted
      bool isDeleted = await clientSdkService.delete(atKey);
      print(isDeleted);
      isDeleted
          ?
          // This will force the authenticated atsign back to the previous screen
          // without the capability of returning to the screen of the recipe that was
          // just deleted as this would cause a major error
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(dishWidget!.prevScreen!, (Route<dynamic> route) => false, arguments: true)
          : ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to delete data',
                  textAlign: TextAlign.center,
                ),
              ),
            );
    }
  }
}
