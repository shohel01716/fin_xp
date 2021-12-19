import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  const CustomTheme();

  static  Color loginGradientStart = Color(0xFF070772);
  static Color loginGradientEnd = Color(0xFF070772);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[loginGradientStart, loginGradientEnd],
    stops: <double>[0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
