import 'package:flutter/material.dart';

import 'control_button_add_work.dart';
import 'control_button_select_work.dart';
import '../dialog_work/layout_work_dialog.dart';

class ControlWorkSelector extends StatefulWidget {
  final String label;
  const ControlWorkSelector({required this.label, super.key});

  @override
  State<ControlWorkSelector> createState() => _ControlWorkSelectorState();
}

class _ControlWorkSelectorState extends State<ControlWorkSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
      const ControlButtonAddWork(),
      GestureDetector(
        onTap: () => _showWorkDialog(context),
        child: MouseRegion(
          onEnter: (event) => setState(() {
            _isMouseOver = true;
          }),
          onExit: (event) => setState(() {
            _isMouseOver = false;
          }),
          child: ControlButtonSelectWork(label: widget.label, isMouseOver: _isMouseOver)
        ),
      )
    ]);
  }

  void _showWorkDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LayoutWorkDialog();
        });
  }

  bool _isMouseOver = false;
}
