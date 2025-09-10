import 'package:flutter/material.dart';

import '../theme/theme_extension_icon_button_dangerous.dart';
import 'utilities_icon_button.dart';

class ControlIconButtonDangerous extends StatelessWidget with SizedIconButton {
  final IconData icon;
  final VoidCallback onPressed;
  const ControlIconButtonDangerous(this.icon, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = Theme.of(context).extension<ThemeExtensionIconButtonDangerous>()!.style;
    return buildSizedIconButton(icon: icon, style: style, onPressed: onPressed);
  }
}