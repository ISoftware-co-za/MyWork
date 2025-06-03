import 'package:flutter/material.dart';
import '../icon_button_size_theme_extension.dart';

class IconButtonLarge extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const IconButtonLarge({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeExt = theme.extension<IconButtonSizeThemeExtension>();
    assert(themeExt != null, 'IconButtonSizeThemeExtension must be provided in the Theme extensions.');
    final double iconSize = themeExt!.largeIconSize;
    final double buttonPadding = themeExt.largePadding;
    final double buttonSize = iconSize + buttonPadding;
    return IconButton(
      icon: icon,
      color: color,
      iconSize: iconSize,
      padding: EdgeInsets.all(buttonPadding),
      constraints: BoxConstraints(minWidth: buttonSize, minHeight: buttonSize),
      onPressed: onPressed,
      tooltip: tooltip
    );
  }
}

