import 'package:flutter/material.dart';

Widget mHeading(var value) {
  return Expanded(
      child: Text(
    value,
    maxLines: 2,
    style: const TextStyle(fontSize: 12, color: Colors.white),
  ));
}

TextStyle secondaryTextStyle({
  int? size,
  Color? Color,
  FontWeight weight = FontWeight.normal,
  String? fontFamily,
  double? letterSpacing,
  FontStyle? fontStyle,
  double? wordSpacing,
  TextDecoration? decoration,
  TextDecorationStyle? textDecorationStyle,
  TextBaseline? textBaseline,
  Color? decorationColor,
}) {
  return TextStyle(
    fontSize: size != null ? size.toDouble() : 14,
    color: Color ?? Colors.black,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationStyle: textDecorationStyle,
    decorationColor: decorationColor,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
  );
}
