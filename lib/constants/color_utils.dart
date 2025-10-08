import 'package:flutter/material.dart';

/// Returns a gradient based on the given letter.
/// Same letter -> always same gradient.
Gradient gradientForLetter(String letter) {
  // Use ASCII code of first character
  final code = letter.codeUnitAt(0);

  // Pick two colors from MaterialColors palette
  final colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  // Map code to 2 indices
  final c1 = colors[code % colors.length];
  final c2 = colors[(code ~/ 1) % colors.length];

  return LinearGradient(
    colors: [c1, c2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
