import 'package:flutter/material.dart';

class ThemeExtensionDialogWorkTypesFilter extends ThemeExtension<ThemeExtensionDialogWorkTypesFilter> {
  final double width;
  final double height;
  final double padding;
  final Color backgroundColor;
  final TextStyle headerTextStyle;
  final TextStyle workTypeTextStyle;

  const ThemeExtensionDialogWorkTypesFilter({
    required this.width,
    required this.height,
    required this.padding,
    required this.backgroundColor,
    required this.headerTextStyle,
    required this.workTypeTextStyle,
  });

  @override
  ThemeExtension<ThemeExtensionDialogWorkTypesFilter> copyWith() {
    return ThemeExtensionDialogWorkTypesFilter(
      width: width,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      headerTextStyle: headerTextStyle,
      workTypeTextStyle: workTypeTextStyle,
    );
  }

  @override
  ThemeExtension<ThemeExtensionDialogWorkTypesFilter> lerp(covariant ThemeExtensionDialogWorkTypesFilter? other, double t) {
    if (other == null) return this;
    return ThemeExtensionDialogWorkTypesFilter(
      width: width + (other.width - width) * t,
      height: height + (other.height - height) * t,
      padding: padding + (other.padding - padding) * t,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ?? backgroundColor,
      headerTextStyle: TextStyle.lerp(headerTextStyle, other.headerTextStyle, t) ?? headerTextStyle,
      workTypeTextStyle: TextStyle.lerp(workTypeTextStyle, other.workTypeTextStyle, t) ?? workTypeTextStyle,
    );
  }
}
