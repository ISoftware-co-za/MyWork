import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeExtensionDialogBase {
  final double padding;
  final double horizontalSpacing;
  final double verticalSpacing;

  final Color backgroundColor;
  final Color dialogHeaderColor;
  final TextStyle dialogHeaderTextStyle;
  final Color tableHeaderColor;
  final TextStyle tableHeaderTextStyle;
  final TextStyle normalCellTextStyle;
  final TextStyle emphasisedCellTextStyle;

  const ThemeExtensionDialogBase({
    required this.padding,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.backgroundColor,
    required this.dialogHeaderColor,
    required this.dialogHeaderTextStyle,
    required this.tableHeaderTextStyle,
    required this.normalCellTextStyle,
    required this.emphasisedCellTextStyle,
    required this.tableHeaderColor,
  });

  ThemeExtensionDialogBase copyWith() {
    return ThemeExtensionDialogBase(
      padding: padding,
      verticalSpacing: verticalSpacing,
      horizontalSpacing: horizontalSpacing,
      backgroundColor: backgroundColor,
      dialogHeaderColor: dialogHeaderColor,
      dialogHeaderTextStyle: dialogHeaderTextStyle,
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
      padding: lerpDouble(padding, other.padding, t)!,
      verticalSpacing: lerpDouble(verticalSpacing, other.verticalSpacing, t)!,
      horizontalSpacing: lerpDouble(
        horizontalSpacing,
        other.horizontalSpacing,
        t,
      )!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
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
