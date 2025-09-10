import 'package:flutter/material.dart';

class ThemeExtensionControlIconButton
    extends ThemeExtension<ThemeExtensionControlIconButton> {
  final ButtonStyle style;

  const ThemeExtensionControlIconButton({required this.style});

  @override
  ThemeExtension<ThemeExtensionControlIconButton> copyWith() {
    return ThemeExtensionControlIconButton(style: style);
  }

  @override
  ThemeExtension<ThemeExtensionControlIconButton> lerp(
    covariant ThemeExtensionControlIconButton? other,
    double t,
  ) {
    if (other == null) return this;
    return ThemeExtensionControlIconButton(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}
