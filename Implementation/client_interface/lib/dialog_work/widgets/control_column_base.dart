import 'package:flutter/material.dart';

import '../../ui_toolkit/control_icon_button_small.dart';
import '../app/column_base.dart';

class ControlColumnBase extends StatelessWidget {
   ControlColumnBase({required Widget child, required ColumnBase column, required TextStyle labelStyle, super.key})
      : _child = child,
        _column = column,
         _labelStyle = labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(_column.label, textAlign: TextAlign.center, style: _labelStyle),
            ),
            if (_column.hasFilerValue.value)
              Positioned(
                right: 0,
                child: ControlIconButtonSmall(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _column.resetFilter();
                    }),
              )
          ],
        ),
        SizedBox(
          height: 34,
          child: Align(alignment: Alignment.center, child: _child),
        )
      ],
    );
  }

  final Widget _child;
  final ColumnBase _column;
  final TextStyle _labelStyle;
}
