import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:flutter/material.dart';
import 'package:chefcookbook/service/client_sdk_service.dart';

// ignore: must_be_immutable
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

  // Add a key/value pair to the logged-in secondary server.
  // Passing multiple key values to be cached in a secondary server
  Future<void> _update(BuildContext context) async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    String? atSign = clientSdkService.atsign;
    // If all of the necessary text form fields have been properly
    // populated
    FormState? form = _formKey.currentState;
    if (form!.validate()) {
      // The information inputted by the authenticated atsign
      // Each field's value is separated by a constant.splitter
      // which is defined as @_@ so when a recipe is shared and received by
      // another secondary server, the at_cookbook app will understand how to
      // distribute the values correctly into their respectful fields
      String _values = _description! + constant.splitter + _ingredients!;

      // If the authenticated atsign did not provide an image URL,
      // we automatically add the image with the question mark as
      // an image is required to be passed through
      if (_imageURL != null) {
        _values += constant.splitter + _imageURL!;
      }

      // Instantiating an AtKey object and specifying its attributes with the
      // recipe title and the atsign that created it
      AtKey atKey = AtKey();
      atKey.key = _title;
      atKey.sharedWith = atSign;

      // Utilizing the put method to take the AtKey object and its values
      // and 'put' it on the secondary server of the authenticated atsign
      // (the atsign currently logged in)
      bool successPut = await clientSdkService.put(atKey, _values);

      // This will take the authenticated atsign from the add_dish page back
      // to the home screen
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
      // If the authenticated atsign has not properly populated the
      // text form fields, this statement will be printed
      print('Not all text fields have been completed!');
    }
  }
}
