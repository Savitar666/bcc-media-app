import 'package:flutter/material.dart';

class AppTabThemeData {
  final Gradient? iconActiveGradient;
  final Color? activeColor;

  AppTabThemeData({
    this.iconActiveGradient,
    this.activeColor,
  });
}

class AppThemeData {
  final Gradient studyGradient;
  final Gradient achievementBackgroundGradient;
  final Gradient genericBackgroundGradient;
  final AppTabThemeData? tabTheme;
  final bool appBarTransparent;

  AppThemeData({
    required this.studyGradient,
    required this.achievementBackgroundGradient,
    required this.genericBackgroundGradient,
    required this.appBarTransparent,
    this.tabTheme,
  });
}
