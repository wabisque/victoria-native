import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHexString() => '#${red.toRadixString(16)}${green.toRadixString(16)}${blue.toRadixString(16)}${alpha.toRadixString(16)}';
}
