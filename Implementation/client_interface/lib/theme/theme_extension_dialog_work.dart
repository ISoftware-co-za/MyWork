import 'dart:ui';

import 'package:flutter/material.dart';

import 'theme_extension_dialog_base.dart';

class ThemeExtensionDialogWork extends ThemeExtension<ThemeExtensionDialogWork> {
  final double width;
  final double height;
  final ThemeExtensionDialogBase dialogBaseTheme;

  const ThemeExtensionDialogWork(
      {required this.width,
      required this.height,
      required this.dialogBaseTheme});

  @override
  ThemeExtension<ThemeExtensionDialogWork> copyWith() {
    return ThemeExtensionDialogWork(
        width: width,
        height: height,
      dialogBaseTheme: dialogBaseTheme,
    );
  }

  @override
  ThemeExtension<ThemeExtensionDialogWork> lerp(covariant ThemeExtensionDialogWork? other, double t) {
    if (other == null) return this;

    return ThemeExtensionDialogWork(
      width: lerpDouble(width, other.width, t)!,
      height: lerpDouble(height, other.height, t)!,
      dialogBaseTheme: dialogBaseTheme.lerp(other.dialogBaseTheme, t));
  }
}
