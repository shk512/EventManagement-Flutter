import 'package:flutter/material.dart';

class Decor {
  static const color = Colors.black87;
  static const lightBlack = Colors.black54;
  static const prime = Colors.deepOrange;
  static const height = SizedBox(
    height: 20,
  );
  static const width = SizedBox(
    width: 20,
  );
  static const divider = SizedBox(
    width: 200,
    height: 30,
    child: Divider(
      thickness: 2.0,
      color: Colors.black87,
    ),
  );
  static const border = InputDecoration(
    labelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    hintStyle: TextStyle(color: Colors.grey),
  );
  /* errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      */ /*focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),*/ /*
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo)));*/
}
