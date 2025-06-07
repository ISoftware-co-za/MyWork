import 'package:flutter/material.dart';

class ThemeExtensionIconButtonAccept extends ThemeExtension<ThemeExtensionIconButtonAccept> {
  final ButtonStyle style;

  const ThemeExtensionIconButtonAccept({required this.style});

  @override
  ThemeExtension<ThemeExtensionIconButtonAccept> copyWith() {
    return ThemeExtensionIconButtonAccept(style: style);
  }

  @override
  ThemeExtension<ThemeExtensionIconButtonAccept> lerp(covariant ThemeExtensionIconButtonAccept? other, double t) {
    if (other == null) return this;
    return ThemeExtensionIconButtonAccept(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}