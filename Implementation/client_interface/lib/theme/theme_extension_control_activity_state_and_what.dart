import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeExtensionControlActivityStateAndWhat
    extends ThemeExtension<ThemeExtensionControlActivityStateAndWhat> {

  final double stateWidth;
  final TextStyle stateTextStyle;
  final BoxConstraints stateHeightConstraints;
  final EdgeInsets contentPadding;

  ThemeExtensionControlActivityStateAndWhat({required this.stateWidth, required this.stateTextStyle, required this.stateHeightConstraints, required this.contentPadding});

  @override
  ThemeExtension<ThemeExtensionControlActivityStateAndWhat> copyWith() {
    return ThemeExtensionControlActivityStateAndWhat(stateWidth: this.stateWidth, stateTextStyle: this.stateTextStyle, stateHeightConstraints: this.stateHeightConstraints, contentPadding: this.contentPadding);
  }

  @override
  ThemeExtension<ThemeExtensionControlActivityStateAndWhat> lerp(covariant ThemeExtensionControlActivityStateAndWhat other, double t) {
    return ThemeExtensionControlActivityStateAndWhat(
        stateWidth: lerpDouble(stateWidth, other.stateWidth, t)!,
        stateTextStyle: stateTextStyle,
        stateHeightConstraints:  stateHeightConstraints,
        contentPadding: contentPadding);
  }
}