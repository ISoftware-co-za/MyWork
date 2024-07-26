import 'package:flutter/material.dart';

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
      _createAddWorkButton(context),
      GestureDetector(
        onTap: () => _showWorkDialog(context),
        child: MouseRegion(
          onEnter: (event) => setState(() {
            _isMouseOver = true;
          }),
          onExit: (event) => setState(() {
            _isMouseOver = false;
          }),
          child: _createSelectWorkContainer(),
        ),
      )
    ]);
  }

  IconButton _createAddWorkButton(BuildContext context) {
    return IconButton(
        iconSize: 40,
        padding: const EdgeInsets.all(2),
        icon: Icon(Icons.add_circle, color: Theme.of(context).appBarTheme.iconTheme!.color),
        onPressed: () {
          debugPrint('Add work button pressed');
        });
  }

  Container _createSelectWorkContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      foregroundDecoration:
          (_isMouseOver) ? BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)) : null,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(widget.label,
            style: const TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.none)),
      ),
    );
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
