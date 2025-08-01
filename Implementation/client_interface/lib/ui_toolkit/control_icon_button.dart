import 'package:flutter/material.dart';

import '../theme/theme_extension_control_icon_button.dart';
import 'utilities_icon_button.dart';

class ControlIconButton extends StatelessWidget with SizedIconButton {
  final IconData icon;
  final VoidCallback onPressed;
  const ControlIconButton(this.icon, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = Theme.of(context).extension<ThemeExtensionControlIconButton>()!.style;
    return buildSizedIconButton(icon: icon, style: style, onPressed: onPressed);
  }
}