import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/work.dart';
import '../theme/theme_extension_control_work_button.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControlButtonSelectWork extends StatelessWidget {
  const ControlButtonSelectWork(
      {required ValueListenable<Work?> selectedWork, required isMouseOver, required workButtonTheme, super.key})
      : _selectedWork = selectedWork,
        _isMouseOver = isMouseOver,
        _workButtonTheme = workButtonTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_workButtonTheme.padding),
      foregroundDecoration: (_isMouseOver)
          ? BoxDecoration(
              border: Border.all(color: _workButtonTheme.hoverColor, width: _workButtonTheme.hoverBorderWidth))
          : null,
      child: ValueListenableBuilder(
          valueListenable: _selectedWork,
          builder: (BuildContext context, Work? value, Widget? child) {
            String label = value?.name.value ?? 'Select Work';
            return Text(label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Restricts the text to a single line
                softWrap: false,
                style: _workButtonTheme.textStyle);
          }),
    );
  }

  final ValueListenable<Work?> _selectedWork;
  final ThemeExtensionControlWorkButton _workButtonTheme;
  final bool _isMouseOver;
}
