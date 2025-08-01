import 'package:flutter/material.dart';

import '../theme/theme_extension_icon_button_size.dart';

class ControlIconButtonSmall extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const ControlIconButtonSmall({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<ThemeExtensionIconButtonSize>();
    assert(themeExt != null, 'IconButtonSizeThemeExtension must be provided in the Theme extensions.');
    final double iconSize = themeExt!.smallIconSize;
    final double buttonSize = iconSize + (padding?.horizontal ?? 4.0);
    return IconButton(
      icon: icon,
      iconSize: iconSize,
      constraints: BoxConstraints(minWidth: buttonSize, minHeight: buttonSize),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: padding ?? const EdgeInsets.all(4.0),
    );
  }
}