import 'dart:ui';

import 'package:flutter/material.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControlButtonSelectWork extends StatelessWidget {
  final String label;
  final bool isMouseOver;
  const ControlButtonSelectWork(
      {required this.label, required this.isMouseOver, super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle = Theme.of(context).appBarTheme.titleTextStyle!;
    ControlWorkButtonTheme workButtonTheme =
        Theme.of(context).extension<ControlWorkButtonTheme>()!;
    return Container(
      padding: EdgeInsets.all(workButtonTheme.padding),
      foregroundDecoration: (isMouseOver)
          ? BoxDecoration(
              border: Border.all(
                  color: workButtonTheme.hoverColor,
                  width: workButtonTheme.hoverBorderWidth))
          : null,
      child:
          Text(label, overflow: TextOverflow.ellipsis,   maxLines: 1,                     // Restricts the text to a single line
              softWrap: false,  style: titleTextStyle),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class ControlWorkButtonTheme extends ThemeExtension<ControlWorkButtonTheme> {
  final double padding;
  final Color hoverColor;
  final double hoverBorderWidth;

  const ControlWorkButtonTheme(
      {required this.padding,
      required this.hoverColor,
      required this.hoverBorderWidth});

  @override
  ThemeExtension<ControlWorkButtonTheme> copyWith() {
    return ControlWorkButtonTheme(
        padding: padding,
        hoverColor: hoverColor,
        hoverBorderWidth: hoverBorderWidth);
  }

  @override
  ThemeExtension<ControlWorkButtonTheme> lerp(
      covariant ControlWorkButtonTheme? other, double t) {
    if (other == null) return this;
    return ControlWorkButtonTheme(
      padding: lerpDouble(padding, other.padding, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
      hoverBorderWidth:
          lerpDouble(hoverBorderWidth, other.hoverBorderWidth, t)!,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------
