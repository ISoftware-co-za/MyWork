import 'package:flutter/material.dart';

class ThemeExtensionIconButtonDangerous extends ThemeExtension<ThemeExtensionIconButtonDangerous> {
  final ButtonStyle style;

  const ThemeExtensionIconButtonDangerous({required this.style});

  @override
  ThemeExtension<ThemeExtensionIconButtonDangerous> copyWith() {
    return ThemeExtensionIconButtonDangerous(style: style);
  }

  @override
  ThemeExtension<ThemeExtensionIconButtonDangerous> lerp(covariant ThemeExtensionIconButtonDangerous? other, double t) {
    if (other == null) return this;
    return ThemeExtensionIconButtonDangerous(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}