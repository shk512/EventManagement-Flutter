import 'package:flutter/material.dart';

import 'decor.dart';

final loading = Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      CircularProgressIndicator(),
      SizedBox(height: 100),
      Text(
        'Working',
        style: TextStyle(color: Decor.lightBlack, fontWeight: FontWeight.bold),
      ),
      Text(
        'Please Wait...',
        style: TextStyle(color: Decor.lightBlack, fontWeight: FontWeight.bold),
      ),
    ],
  ),
);
