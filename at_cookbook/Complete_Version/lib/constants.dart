import 'package:flutter/material.dart';

String root = 'root.atsign.org';
int rootPort = 64;
String namespace = 'at_cookbook';
bool debug = true;
bool verbose = true;
String splitter = '@_@';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  fillColor: Color(0XFFF1EBE5),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0XFFAF8B66), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0XFFAF8B66), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
