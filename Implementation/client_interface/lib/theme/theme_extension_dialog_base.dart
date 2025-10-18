import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeExtensionDialogBase {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BoxShadow dialogShadow;

  final Color dialogHeaderColor;
  final TextStyle dialogHeaderTextStyle;

  final InputDecoration filterInputDecoration;
  final TextStyle filterTextStyle;

  final Color tableHeaderColor;
  final TextStyle tableHeaderTextStyle;
  final TextStyle normalCellTextStyle;
  final TextStyle emphasisedCellTextStyle;

  const ThemeExtensionDialogBase({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.dialogShadow,
    required this.dialogHeaderColor,
    required this.dialogHeaderTextStyle,
    required this.filterInputDecoration,
    required this.filterTextStyle,
    required this.tableHeaderTextStyle,
    required this.normalCellTextStyle,
    required this.emphasisedCellTextStyle,
    required this.tableHeaderColor,
  });

  ThemeExtensionDialogBase copyWith() {
    return ThemeExtensionDialogBase(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      dialogShadow: dialogShadow,
      dialogHeaderColor: dialogHeaderColor,
      dialogHeaderTextStyle: dialogHeaderTextStyle,
      filterInputDecoration: filterInputDecoration,
      filterTextStyle: filterTextStyle,
      tableHeaderColor: tableHeaderColor,
      tableHeaderTextStyle: tableHeaderTextStyle,
      normalCellTextStyle: normalCellTextStyle,
      emphasisedCellTextStyle: emphasisedCellTextStyle,
    );
  }

  ThemeExtensionDialogBase lerp(
    covariant ThemeExtensionDialogBase? other,
    double t,
  ) {
    if (other == null) return this;
    return ThemeExtensionDialogBase(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      dialogShadow: BoxShadow.lerp(dialogShadow, other.dialogShadow, t)!,
      dialogHeaderColor: Color.lerp(
        dialogHeaderColor,
        other.dialogHeaderColor,
        t,
      )!,
      dialogHeaderTextStyle: TextStyle.lerp(
        dialogHeaderTextStyle,
        other.dialogHeaderTextStyle,
        t,
      )!,
      filterInputDecoration: other.filterInputDecoration,
      filterTextStyle: TextStyle.lerp(filterTextStyle, other.filterTextStyle, t)!,
      tableHeaderColor: Color.lerp(
        tableHeaderColor,
        other.tableHeaderColor,
        t,
      )!,
      tableHeaderTextStyle: TextStyle.lerp(
        tableHeaderTextStyle,
        other.tableHeaderTextStyle,
        t,
      )!,
      normalCellTextStyle: TextStyle.lerp(
        normalCellTextStyle,
        other.normalCellTextStyle,
        t,
      )!,
      emphasisedCellTextStyle: TextStyle.lerp(
        emphasisedCellTextStyle,
        other.emphasisedCellTextStyle,
        t,
      )!,
    );
  }
}
