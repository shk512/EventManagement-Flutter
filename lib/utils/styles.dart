import 'dart:ui';
import 'package:flutter/material.dart';
import 'decor.dart';

class Styles {
  static const heading = TextStyle(
    decorationStyle: TextDecorationStyle.dotted,
    letterSpacing: 2,
    color: Decor.prime,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );
  static const text = TextStyle(
    letterSpacing: 1,
    color: Decor.prime,
    fontWeight: FontWeight.bold,
  );
  static const btn = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Decor.prime),
    foregroundColor: MaterialStatePropertyAll(Colors.white),
  );
}
