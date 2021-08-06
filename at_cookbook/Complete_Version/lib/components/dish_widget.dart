import 'package:chefcookbook/screens/dish_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DishWidget extends StatelessWidget {
  final String? title;
  final String? ingredients;
  final String? description;
  final String? imageURL;
  final String? prevScreen;

  DishWidget({
    @required this.title,
    @required this.ingredients,
    @required this.description,
    @required this.imageURL,
    @required this.prevScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            child: imageURL == null
                ? Image.asset('assets/question_mark.png')
                : Image.network(imageURL!),
            height: 80,
            width: 80,
          ),
          title: Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            description!.length >= 20
                ? description!.substring(0, 20) + '...'
                : description!.substring(0, description!.length),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                return DishPage(dishWidget: this);
              }));
            },
          ),
        ),
      ),
    );
  }
}
