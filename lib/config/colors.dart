import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xff00A302);
const Color kBadgeColor = Colors.red;
const Color fbContainerBgColor = Color(0xff1C4EDB);
const Color gradientColor1 = Color(0xff575768);
const Color gradientColor2 = Color(0xff3e3e48);
const Color gradientColor1Light = Colors.white70;
const Color gradientColor2Light = Colors.white60;
const Color cardColor = Color(0xfff5f7f9);

Color orderGreen = const Color(0xff7AC81E);
Color orderGreenLight = const Color(0xffE9FFCE);
Color orderOrange = const Color(0xffF3AA1B);
Color orderOrangeLight = const Color(0xffFFEAC2);
Color orderBlack = const Color(0xff27292E);
Color orderBlackLight = const Color(0xffEFF1F6);

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
