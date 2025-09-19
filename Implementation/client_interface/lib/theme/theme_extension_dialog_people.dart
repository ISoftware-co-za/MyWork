import 'dart:ui';

import 'package:flutter/material.dart';

import 'theme_extension_dialog_base.dart';

class ThemeExtensionDialogPeople
    extends ThemeExtension<ThemeExtensionDialogPeople> {
  final double width;
  final double height;
  final double selectionColumnWidth;
  final double commandColumnWidth;
  final ThemeExtensionDialogBase dialogBaseTheme;

  const ThemeExtensionDialogPeople({
    required this.width,
    required this.height,
    required this.selectionColumnWidth,
    required this.commandColumnWidth,
    required this.dialogBaseTheme,
  });

  @override
  ThemeExtension<ThemeExtensionDialogPeople> copyWith() {
    return ThemeExtensionDialogPeople(
      width: width,
      height: height,
      selectionColumnWidth: selectionColumnWidth,
      commandColumnWidth: commandColumnWidth,
      dialogBaseTheme: dialogBaseTheme,
    );
  }

  @override
  ThemeExtension<ThemeExtensionDialogPeople> lerp(
    covariant ThemeExtensionDialogPeople? other,
    double t,
  ) {
    if (other == null) return this;

    return ThemeExtensionDialogPeople(
      width: lerpDouble(width, other.width, t)!,
      height: lerpDouble(height, other.height, t)!,
      selectionColumnWidth: lerpDouble(selectionColumnWidth, other.selectionColumnWidth, t)!,
      commandColumnWidth: lerpDouble(commandColumnWidth, other.commandColumnWidth, t)!,
      dialogBaseTheme: dialogBaseTheme.lerp(other.dialogBaseTheme, t),
    );
  }
}
