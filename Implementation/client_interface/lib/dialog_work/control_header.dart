import 'dart:ui';
import 'package:flutter/material.dart';

import '../ui toolkit/custom_icon_buttons.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControlHeader extends StatelessWidget {
  const ControlHeader({super.key});

  @override
  Widget build(BuildContext context) {
    WorkDialogTheme theme = Theme.of(context).extension<WorkDialogTheme>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Work', style: theme.headerTextStyle),
        SizedBox(width: theme.gridSize),
        IconButtonAction(Icons.add, onPressed: () => debugPrint('Add work pressed')),
        const Spacer(),
        IconButtonAction(Icons.close, onPressed: () => Navigator.pop(context))
      ],
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class WorkDialogTheme extends ThemeExtension<WorkDialogTheme> {

  final double gridSize;
  final TextStyle headerTextStyle;
  final double width;
  final double height;
  final Color backgroundColor;

  const WorkDialogTheme({
    required this.gridSize,
    required this.headerTextStyle,
    required this.width,
    required this.height,
    required this.backgroundColor,
  });

  @override
  ThemeExtension<WorkDialogTheme> copyWith() {
    return WorkDialogTheme(
      gridSize: gridSize,
      headerTextStyle: headerTextStyle,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
    );
  }

  @override
  ThemeExtension<WorkDialogTheme> lerp(covariant WorkDialogTheme? other, double t) {
    if (other == null) return this;
    return WorkDialogTheme(
      gridSize: lerpDouble(gridSize, other.gridSize, t)!,
      headerTextStyle: TextStyle.lerp(headerTextStyle, other.headerTextStyle, t)!,
      width: lerpDouble(width, other.width, t)!,
      height: lerpDouble(height, other.height, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------
