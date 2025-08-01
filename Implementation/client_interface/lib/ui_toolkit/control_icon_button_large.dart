import 'package:flutter/material.dart';

import '../theme/theme_extension_icon_button_size.dart';

class ControlIconButtonLarge extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const ControlIconButtonLarge({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeExt = theme.extension<ThemeExtensionIconButtonSize>();
    assert(themeExt != null, 'IconButtonSizeThemeExtension must be provided in the Theme extensions.');
    final double iconSize = themeExt!.largeIconSize;
    final double buttonPadding = themeExt.largePadding;
    final double buttonSize = iconSize + buttonPadding;
    return IconButton(
      icon: icon,
      iconSize: iconSize,
      padding: EdgeInsets.all(buttonPadding),
      constraints: BoxConstraints(minWidth: buttonSize, minHeight: buttonSize),
      onPressed: onPressed,
      tooltip: tooltip
    );
  }
}

