import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeModel {
  Color normalTxtColor;
  Color appBarTitleTxtColor;
  Color appBarBgColor;
  Color appBarBackIconColor;



  ThemeModel(this.normalTxtColor, this.appBarTitleTxtColor, this.appBarBgColor,
      this.appBarBackIconColor);




  static ThemeModel  mapStringToThmemeModel(themeIndex) {
    switch (themeIndex) {
      case 1:
        return ThemeModel(
            Colors.black, Colors.black, Colors.white, Colors.black);
        break;

      case 2:
        return ThemeModel(
            Colors.white, Colors.white, Colors.black, Colors.white);
        break;
      default:
        return ThemeModel(
            Colors.black, Colors.black, Colors.white, Colors.black);
    }
  }
}
