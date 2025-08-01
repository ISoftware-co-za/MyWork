import 'package:flutter/material.dart';

class ThemeExtensionTextField extends ThemeExtension<ThemeExtensionTextField> {
  final InputDecoration textFieldDecoration;
  final InputDecoration textFieldDecorationError;
  final TextStyle invalidMessageStyle;

  const ThemeExtensionTextField({
    required this.textFieldDecoration,
    required this.textFieldDecorationError,
    required this.invalidMessageStyle
  });

  @override
  ThemeExtension<ThemeExtensionTextField> copyWith({
    InputDecoration? textFieldDecoration,
    InputDecoration? textFieldDecorationError,
    TextStyle? invalidMessageStyle}) {
    return ThemeExtensionTextField(
      textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
      textFieldDecorationError: textFieldDecorationError ?? this.textFieldDecorationError,
invalidMessageStyle: invalidMessageStyle ?? this.invalidMessageStyle
    );
  }

  @override
  ThemeExtension<ThemeExtensionTextField> lerp(
      covariant ThemeExtension<ThemeExtensionTextField>? other, double t) {
    if (other is! ThemeExtensionTextField) return this;
    return ThemeExtensionTextField(
      textFieldDecoration:  other.textFieldDecoration,
      textFieldDecorationError: other.textFieldDecorationError,
      invalidMessageStyle: other.invalidMessageStyle
    );
  }
}