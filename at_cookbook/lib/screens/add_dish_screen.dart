import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:flutter/material.dart';

class DishScreen extends StatelessWidget {
  static final String id = 'add_dish';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _title;
  String? _ingredients;
  String? _description;
  String? _imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a dish'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag: 'choice chef',
                          child: SizedBox(
                            height: 120,
                            child: Image.asset(
                              'assets/chef.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Name of the dish',
                          labelText: 'Name',
                        ),
                        validator: (String? value) =>
                            value!.isEmpty ? 'Specify name of the dish' : null,
                        onChanged: (String value) {
                          _title = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Short description for your dish',
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        validator: (String? value) =>
                            value!.isEmpty ? 'Provide a description' : null,
                        onChanged: (String value) {
                          _description = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Separate ingredients by commas',
                          labelText: 'Ingredients',
                        ),
                        validator: (String? value) =>
                            value!.isEmpty ? 'Add some ingredients' : null,
                        onChanged: (String value) {
                          _ingredients = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Optional: link to an image of the cuisine',
                          labelText: 'Image',
                        ),
                        onChanged: (String value) {
                          _imageURL = value;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      RoundedButton(
                        text: 'Add Cuisine',
                        color: const Color(0XFF7B3F00),
                        path: () => _update(context),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<void> _update(BuildContext context) async {
    String? atSign = AtClientManager.getInstance().atClient.getCurrentAtSign();

    FormState? form = _formKey.currentState;
    if (form!.validate()) {
      String _values = _description! + constant.splitter + _ingredients!;

      if (_imageURL != null) {
        _values += constant.splitter + _imageURL!;
      }

      AtKey atKey = AtKey();
      atKey.key = _title;
      atKey.sharedWith = atSign;

      bool successPut =
          await AtClientManager.getInstance().atClient.put(atKey, _values);

      successPut
          ? Navigator.pop(context)
          : ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to put data',
                  textAlign: TextAlign.center,
                ),
              ),
            );
    } else {
      print('Not all text fields have been completed!');
    }
  }
}
