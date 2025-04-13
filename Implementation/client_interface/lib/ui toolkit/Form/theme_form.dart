library form;

import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../state/properties.dart';

part 'control_form_field.dart';
part 'control_fleather_form_field.dart';
part 'control_automcomplete_form_fields.dart';
part 'auto_complete_form_field_data_source.dart';

class ThemeForm extends ThemeExtension<ThemeForm> {
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final TextStyle valueStyleError;
  final InputDecoration textFieldDecoration;
  final InputDecoration textFieldDecorationChanged;
  final InputDecoration textFieldDecorationError;
  final double fleatherEditorHeight;

  const ThemeForm({
    required this.labelStyle,
    required this.valueStyle,
    required this.valueStyleError,
    required this.textFieldDecoration,
    required this.textFieldDecorationChanged,
    required this.textFieldDecorationError,
    required this.fleatherEditorHeight,
  });

  @override
  ThemeExtension<ThemeForm> copyWith() {
    return ThemeForm(
      labelStyle: labelStyle,
      valueStyle: valueStyle,
      valueStyleError: valueStyleError,
      textFieldDecoration: textFieldDecoration,
      textFieldDecorationChanged: textFieldDecorationChanged,
      textFieldDecorationError: textFieldDecorationError,
      fleatherEditorHeight: fleatherEditorHeight,
    );
  }

  @override
  ThemeExtension<ThemeForm> lerp(covariant ThemeForm? other, double t) {
    if (other == null) return this;
    return ThemeForm(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t)!,
      valueStyleError:
          TextStyle.lerp(valueStyleError, other.valueStyleError, t)!,
      textFieldDecoration: other.textFieldDecoration,
      textFieldDecorationChanged: other.textFieldDecorationChanged,
      textFieldDecorationError: other.textFieldDecorationError,
      fleatherEditorHeight: fleatherEditorHeight +
          (other.fleatherEditorHeight - fleatherEditorHeight) * t,
    );
  }
}
