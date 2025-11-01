import 'package:flutter/material.dart';

import 'package:deligo_delivery/config/colors.dart';

const String fontFamily = 'Poppins';

class AppTheme {
  static Color pc = kPrimaryColor;
  static Color pcDark = kPrimaryColor;
  static final ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    cardColor: const Color(0xfff5f7f9),
    hintColor: const Color(0xff979ca7),
    primaryColor: pc,
    primaryColorDark: Colors.black,
    canvasColor: const Color(0xFFF4F7F9),
    fontFamily: fontFamily,
    dividerColor: const Color(0xffd2d4cf),
    primaryColorLight: Colors.black,
    unselectedWidgetColor: const Color(0xff979ca7),

    ///appBar theme
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white),

    ///text theme
    textTheme: const TextTheme(
      titleSmall: TextStyle(),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(),
      labelLarge: TextStyle(),
      bodySmall: TextStyle(
        color: Color(0xff979ca7),
        fontSize: 15,
      ), //caption
    ),
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: cardColor,
      cardColor: cardColor,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: pc,
      selectionColor: pc.withValues(alpha: 0.3),
      selectionHandleColor: pc,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: pcDark,
    primaryColorDark: Colors.white,
    cardColor: Color(0xff1e1e1e),
    hintColor: const Color(0xff979ca7),
    dividerColor: const Color(0xffd2d4cf),
    canvasColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
    primaryColorLight: Colors.white,
    unselectedWidgetColor: const Color(0xff979ca7),

    ///appBar theme
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      elevation: 0,
      backgroundColor: Colors.black,
    ),

    ///text theme
    textTheme: const TextTheme(
      titleSmall: TextStyle(fontFamily: fontFamily),
      titleLarge:
          TextStyle(fontWeight: FontWeight.w500, fontFamily: fontFamily),
      bodyLarge: TextStyle(fontFamily: fontFamily),
      labelLarge: TextStyle(fontFamily: fontFamily),
      bodySmall: TextStyle(
          color: Color(0xff979ca7),
          fontSize: 15,
          fontFamily: fontFamily), //caption
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFF1F2F3),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFE1EAF6),
      onSecondary: Color(0xFF979ca7),
      error: Color(0xFFF32424),
      onError: Color(0xFFF32424),
      surface: Color(0xFF222222),
      onSurface: Colors.white,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: pcDark,
      selectionColor: pcDark.withValues(alpha: 0.3),
      selectionHandleColor: pcDark,
    ),
  );
}

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
