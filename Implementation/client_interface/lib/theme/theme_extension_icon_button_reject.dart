import 'package:flutter/material.dart';

class ThemeExtensionIconButtonReject extends ThemeExtension<ThemeExtensionIconButtonReject> {
  final ButtonStyle style;

  const ThemeExtensionIconButtonReject({required this.style});

  @override
  ThemeExtension<ThemeExtensionIconButtonReject> copyWith() {
    return ThemeExtensionIconButtonReject(style: style);
  }

  @override
  ThemeExtension<ThemeExtensionIconButtonReject> lerp(covariant ThemeExtensionIconButtonReject? other, double t) {
    if (other == null) return this;
    return ThemeExtensionIconButtonReject(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}