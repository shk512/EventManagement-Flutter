import 'dart:html';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Signature = Column(
  children: [
    Text(
      'Developed By',
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        decoration: TextDecoration.underline,
      ),
    ),
    const SizedBox(
      height: 5,
    ),
    const Text(
      'Flutter Tech',
      style: TextStyle(
        color: Colors.black54,
        letterSpacing: 3,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
);
