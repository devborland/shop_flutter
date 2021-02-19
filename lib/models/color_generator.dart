import 'package:flutter/material.dart' show Color;
import 'dart:math' show Random;

class ColorGenerator {
  static Random _random = new Random();
  static Color getColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
    );
  }
}
