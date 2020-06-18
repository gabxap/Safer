import 'package:flutter/material.dart';

class SaferColors {
  int getSaferGreen() {
    return 0xFF40DC6D;
  }

  MaterialColor getSaferGreenMaterialColor() {
    return MaterialColor(getSaferGreen(), <int, Color>{
      50: Color(0xFFF1F8E9),
      100: Color(0xFFDCEDC8),
      200: Color(0xFFC5E1A5),
      300: Color(0xFFAED581),
      400: Color(0xFF9CCC65),
      500: Color(getSaferGreen()),
      600: Color(0xFF7CB342),
      700: Color(0xFF689F38),
      800: Color(0xFF558B2F),
      900: Color(0xFF33691E),
    });
  }

  int getSplashGray() {
    return 0xFFD6D6D6;
  }
}
