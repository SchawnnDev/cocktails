import 'package:flutter/material.dart';

///  Light Theme
ThemeData lightTheme = ThemeData(
  primaryColor: Color(0xFFBAA9DB),
    fontFamily: 'Karla'
);

/// Dark Theme
ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Color(0xFFBAA9DB),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color(0xFF0f0d13),

  ),
);

Color primColor(BuildContext ctx, int idx) =>
    Theme.of(ctx).primaryColor.withOpacity(idx % 2 == 0 ? 0.6 : 0.3);

Color getPrimColor(BuildContext ctx) => Theme.of(ctx).primaryColor;
