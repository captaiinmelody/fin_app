import 'package:flutter/material.dart';

class TextStyles {
  static const String defaultFonts = 'Montserrat';

  static const TextStyle titleText = TextStyle(
    fontFamily: defaultFonts,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle normalText = TextStyle(
    fontFamily: defaultFonts,
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle smallText = TextStyle(
    fontFamily: defaultFonts,
    fontSize: 12,
    color: Colors.grey,
  );
}
