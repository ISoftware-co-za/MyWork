import 'package:flutter/material.dart';
import '../icon_button_size_theme_extension.dart';

class IconButtonSmall extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const IconButtonSmall({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<IconButtonSizeThemeExtension>();
    assert(themeExt != null, 'IconButtonSizeThemeExtension must be provided in the Theme extensions.');
    final double iconSize = themeExt!.smallIconSize;
    final double buttonSize = iconSize + (padding?.horizontal ?? 4.0);
    return IconButton(
      icon: icon,
      iconSize: iconSize,
      constraints: BoxConstraints(minWidth: buttonSize, minHeight: buttonSize),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      padding: padding ?? const EdgeInsets.all(4.0),
    );
  }
}