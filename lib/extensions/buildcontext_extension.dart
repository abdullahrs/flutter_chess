import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  TextTheme get appTextTheme => appTheme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get topPadding => mediaQuery.padding.top;
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  double dynamicHeight(double ratio) => mediaQuery.size.height * ratio;
  double dynamicWidth(double ratio) => mediaQuery.size.width * ratio;
}
