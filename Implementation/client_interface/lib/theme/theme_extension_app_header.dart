import 'dart:ui';
import 'package:flutter/material.dart';

class ThemeExtensionAppHeader extends ThemeExtension<ThemeExtensionAppHeader> {
  final Color backgroundColor;
  final double height;
  final double padding;

  const ThemeExtensionAppHeader({required this.backgroundColor, required this.height, required this.padding});

  @override
  ThemeExtension<ThemeExtensionAppHeader> copyWith() {
    return ThemeExtensionAppHeader(
      backgroundColor: backgroundColor,
      height: height,
      padding: padding
    );
  }

  @override
  ThemeExtension<ThemeExtensionAppHeader> lerp(covariant ThemeExtensionAppHeader? other, double t) {
    if (other == null) return this;
    return ThemeExtensionAppHeader(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      height: lerpDouble(height, other.height, t)!,
      padding: lerpDouble(padding, other.padding, t)!
    );
  }
}
