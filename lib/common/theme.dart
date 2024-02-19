import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: TColor.primaryColor1,
  fontFamily: "Poppins",
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  primaryColor: TColor.primaryColor2,
  fontFamily: "Poppins",
  brightness: Brightness.dark,
  hintColor: Colors.blueGrey,
);
