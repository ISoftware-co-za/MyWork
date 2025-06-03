import 'dart:ui';
import 'package:flutter/material.dart';

class ThemeExtensionControlWorkButton extends ThemeExtension<ThemeExtensionControlWorkButton> {
  final double padding;
  final Color hoverColor;
  final double hoverBorderWidth;
  final TextStyle textStyle;

  const ThemeExtensionControlWorkButton(
      {required this.padding, required this.hoverColor, required this.hoverBorderWidth, required this.textStyle});

  @override
  ThemeExtension<ThemeExtensionControlWorkButton> copyWith() {
    return ThemeExtensionControlWorkButton(
        padding: padding, hoverColor: hoverColor, hoverBorderWidth: hoverBorderWidth, textStyle: textStyle);
  }

  @override
  ThemeExtension<ThemeExtensionControlWorkButton> lerp(covariant ThemeExtensionControlWorkButton? other, double t) {
    if (other == null) return this;
    return ThemeExtensionControlWorkButton(
      padding: lerpDouble(padding, other.padding, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
      hoverBorderWidth: lerpDouble(hoverBorderWidth, other.hoverBorderWidth, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }
}
