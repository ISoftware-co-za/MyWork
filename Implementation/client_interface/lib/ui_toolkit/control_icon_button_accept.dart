import 'package:flutter/material.dart';

import '../theme/theme_extension_icon_button_accept.dart';
import 'utilities_icon_button.dart';

class ControlIconButtonAccept extends StatelessWidget with SizedIconButton {
  final IconData icon;
  final VoidCallback onPressed;
  const ControlIconButtonAccept(this.icon, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = Theme.of(context).extension<ThemeExtensionIconButtonAccept>()!.style;
    return buildSizedIconButton(icon: icon, style: style, onPressed: onPressed);
  }
}