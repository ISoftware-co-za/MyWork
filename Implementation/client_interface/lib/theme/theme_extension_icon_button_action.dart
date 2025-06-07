import 'package:flutter/material.dart';

class ThemeExtensionIconButtonAction extends ThemeExtension<ThemeExtensionIconButtonAction> {
  final ButtonStyle style;

  const ThemeExtensionIconButtonAction({required this.style});

  @override
  ThemeExtension<ThemeExtensionIconButtonAction> copyWith() {
    return ThemeExtensionIconButtonAction(style: style);
  }

  @override
  ThemeExtension<ThemeExtensionIconButtonAction> lerp(covariant ThemeExtensionIconButtonAction? other, double t) {
    if (other == null) return this;
    return ThemeExtensionIconButtonAction(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}