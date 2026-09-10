import 'package:flutter/material.dart';

Color parseHexColor(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  final value = int.parse(cleaned.length == 6 ? 'FF$cleaned' : cleaned, radix: 16);
  return Color(value);
}
