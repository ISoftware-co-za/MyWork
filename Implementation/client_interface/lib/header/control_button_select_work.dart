import 'package:flutter/material.dart';

import '../theme_extension_control_work_button.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControlButtonSelectWork extends StatelessWidget {
  final String label;
  final ThemeExtensionControlWorkButton workButtonTheme;
  final bool isMouseOver;
  const ControlButtonSelectWork({required this.label, required this.workButtonTheme, required this.isMouseOver, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(workButtonTheme.padding),
      foregroundDecoration: (isMouseOver)
          ? BoxDecoration(
              border: Border.all(color: workButtonTheme.hoverColor, width: workButtonTheme.hoverBorderWidth))
          : null,
      child: Text(label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1, // Restricts the text to a single line
          softWrap: false,
          style: workButtonTheme.textStyle),
    );
  }
}
