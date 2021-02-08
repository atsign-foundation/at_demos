import 'package:chefcookbook/components/rounded_button.dart';
import 'package:chefcookbook/service.dart';
import 'welcome_screen.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DishScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _title;
  String _ingredients;
  String _description;
  String _imageURL;
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF7B3F00),
        title: Text(
          'Add a dish'
        ),
      ),
      backgroundColor: Color(0XFFF1EBE5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 120,
                        child: Image.asset(
                          'assets/chef.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.approval),
                        hintText: 'Name of the dish',
                        labelText: 'Name',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'Specify name of the dish' : null,
                      onChanged: (value) {
                        _title = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.approval),
                        hintText: 'Short description for your dish',
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      validator: (value) =>
                      value.isEmpty ? 'Provide a description' : null,
                      onChanged: (value) {
                        _description = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.approval),
                        hintText: 'Separate ingredients by commas',
                        labelText: 'Ingredients',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'Add some ingredients' : null,
                      onChanged: (value) {
                        _ingredients = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.approval),
                        hintText: 'Link to an image of the cuisine',
                        labelText: 'Image',
                      ),
                      onChanged: (value) {
                        _imageURL = value;
                      },
                      validator: (value) =>
                      value.isEmpty ? 'Paste an image URL' : null,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RoundedButton(
                      text: 'Add Cuisine',
                      color: Color(0XFF7B3F00),
                      path: () => _update(context),
                    )
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }

  _update(BuildContext context) async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      String _values = _description + constant.splitter
          + _ingredients + constant.splitter + _imageURL;
      AtKey atKey = AtKey();
      atKey.key = _title;
      atKey.sharedWith = atSign;
      await _serverDemoService.put(atKey, _values);
      Navigator.pop(context);
    } else {
      print('Not all text fields have been completed!');
    }
  }
}
