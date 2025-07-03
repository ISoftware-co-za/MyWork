part of form;

class ThemeExtensionForm extends ThemeExtension<ThemeExtensionForm> {
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final TextStyle valueStyleEmphasised;
  final TextStyle valueStyleError;
  final TextStyle valueStyleErrorEmphasised;
  final InputDecoration textFieldDecoration;
  final InputDecoration textFieldDecorationChanged;
  final InputDecoration textFieldDecorationError;
  final double fleatherEditorHeight;

  const ThemeExtensionForm({
    required this.labelStyle,
    required this.valueStyle,
    required this.valueStyleEmphasised,
    required this.valueStyleError,
    required this.valueStyleErrorEmphasised,
    required this.textFieldDecoration,
    required this.textFieldDecorationChanged,
    required this.textFieldDecorationError,
    required this.fleatherEditorHeight,
  });

  @override
  ThemeExtension<ThemeExtensionForm> copyWith() {
    return ThemeExtensionForm(
      labelStyle: labelStyle,
      valueStyle: valueStyle,
      valueStyleEmphasised: valueStyleEmphasised,
      valueStyleError: valueStyleError,
      valueStyleErrorEmphasised: valueStyleErrorEmphasised,
      textFieldDecoration: textFieldDecoration,
      textFieldDecorationChanged: textFieldDecorationChanged,
      textFieldDecorationError: textFieldDecorationError,
      fleatherEditorHeight: fleatherEditorHeight,
    );
  }

  @override
  ThemeExtension<ThemeExtensionForm> lerp(covariant ThemeExtensionForm? other, double t) {
    if (other == null) return this;
    return ThemeExtensionForm(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t)!,
      valueStyleEmphasised: TextStyle.lerp(valueStyleEmphasised, other.valueStyleEmphasised, t)!,
      valueStyleError:
      TextStyle.lerp(valueStyleError, other.valueStyleError, t)!,
      valueStyleErrorEmphasised: TextStyle.lerp(valueStyleErrorEmphasised, other.valueStyleErrorEmphasised, t)!,
      textFieldDecoration: other.textFieldDecoration,
      textFieldDecorationChanged: other.textFieldDecorationChanged,
      textFieldDecorationError: other.textFieldDecorationError,
      fleatherEditorHeight: fleatherEditorHeight +
          (other.fleatherEditorHeight - fleatherEditorHeight) * t,
    );
  }
}
