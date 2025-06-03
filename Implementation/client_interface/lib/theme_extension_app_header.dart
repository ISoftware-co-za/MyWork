import 'dart:ui';
import 'package:flutter/material.dart';

class ThemeExtensionAppHeader extends ThemeExtension<ThemeExtensionAppHeader> {
  final Color backgroundColor;
  final double height;

  const ThemeExtensionAppHeader({required this.backgroundColor, required this.height});

  @override
  ThemeExtension<ThemeExtensionAppHeader> copyWith() {
    return ThemeExtensionAppHeader(
      backgroundColor: backgroundColor,
      height: height
    );
  }

  @override
  ThemeExtension<ThemeExtensionAppHeader> lerp(covariant ThemeExtensionAppHeader? other, double t) {
    if (other == null) return this;
    return ThemeExtensionAppHeader(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      height: lerpDouble(height, other.height, t)!
    );
  }
}
