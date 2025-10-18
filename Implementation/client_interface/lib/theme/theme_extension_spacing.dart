import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeExtensionSpacing extends ThemeExtension<ThemeExtensionSpacing> {
  final double paddingNarrow;
  final double paddingWide;
  final EdgeInsets edgeInsetsNarrow;
  final EdgeInsets edgeInsetsWide;
  final double horizontalSpacing;
  final double verticalSpacing;

  ThemeExtensionSpacing({required this.paddingNarrow, required this.paddingWide, required this.edgeInsetsNarrow, required this.edgeInsetsWide, required this. horizontalSpacing, required this.verticalSpacing});

  @override
  ThemeExtension<ThemeExtensionSpacing> copyWith() {
    return ThemeExtensionSpacing(
      paddingNarrow: this.paddingNarrow,
      paddingWide: this.paddingWide,
      edgeInsetsNarrow: this.edgeInsetsNarrow,
      edgeInsetsWide: this.edgeInsetsWide,
      horizontalSpacing: this.horizontalSpacing,
      verticalSpacing: this.verticalSpacing
    );
  }

  @override
  ThemeExtension<ThemeExtensionSpacing> lerp(covariant ThemeExtensionSpacing? other, double t) {
    if (other == null) return this;
    return ThemeExtensionSpacing(
      paddingNarrow: lerpDouble(paddingNarrow, other.paddingNarrow, t)!,
      paddingWide: lerpDouble(paddingWide, other.paddingWide, t)!,
        edgeInsetsNarrow: EdgeInsets.lerp(edgeInsetsNarrow, other.edgeInsetsNarrow, t)!,
      edgeInsetsWide: EdgeInsets.lerp(edgeInsetsWide, other.edgeInsetsWide, t)!,
      horizontalSpacing: lerpDouble(horizontalSpacing, other.horizontalSpacing, t)!,
      verticalSpacing: lerpDouble(verticalSpacing, other.verticalSpacing, t)!,
    );
  }
}