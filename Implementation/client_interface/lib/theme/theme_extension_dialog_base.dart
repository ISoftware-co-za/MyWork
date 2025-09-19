import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeExtensionDialogBase {
  final double paddingWide;
  final double paddingNarrow;
  final EdgeInsets edgeInsetsWide;
  final EdgeInsets edgeInsetsNarrow;
  final double horizontalSpacing;
  final double verticalSpacing;

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
    required this.paddingWide,
    required this.paddingNarrow,
    required this.edgeInsetsWide,
    required this.edgeInsetsNarrow,
    required this.horizontalSpacing,
    required this.verticalSpacing,
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
      paddingWide: paddingWide,
      paddingNarrow: paddingNarrow,
      edgeInsetsWide: edgeInsetsWide,
      edgeInsetsNarrow: edgeInsetsNarrow,
      verticalSpacing: verticalSpacing,
      horizontalSpacing: horizontalSpacing,
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
      paddingWide: lerpDouble(paddingWide, other.paddingWide, t)!,
      paddingNarrow: lerpDouble(paddingNarrow, other.paddingNarrow, t)!,
      edgeInsetsWide: EdgeInsets.lerp(edgeInsetsWide, other.edgeInsetsWide, t)!,
      edgeInsetsNarrow: EdgeInsets.lerp(edgeInsetsNarrow, other.edgeInsetsNarrow, t)!,
      verticalSpacing: lerpDouble(verticalSpacing, other.verticalSpacing, t)!,
      horizontalSpacing: lerpDouble(
        horizontalSpacing,
        other.horizontalSpacing,
        t,
      )!,
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
