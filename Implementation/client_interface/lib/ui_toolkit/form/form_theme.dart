part of form;

class FormTheme extends ThemeExtension<FormTheme> {
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final TextStyle valueStyleError;
  final InputDecoration textFieldDecoration;
  final InputDecoration textFieldDecorationChanged;
  final InputDecoration textFieldDecorationError;
  final double fleatherEditorHeight;

  const FormTheme({
    required this.labelStyle,
    required this.valueStyle,
    required this.valueStyleError,
    required this.textFieldDecoration,
    required this.textFieldDecorationChanged,
    required this.textFieldDecorationError,
    required this.fleatherEditorHeight,
  });

  @override
  ThemeExtension<FormTheme> copyWith() {
    return FormTheme(
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
  ThemeExtension<FormTheme> lerp(covariant FormTheme? other, double t) {
    if (other == null) return this;
    return FormTheme(
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