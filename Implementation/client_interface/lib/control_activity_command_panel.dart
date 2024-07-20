import 'package:flutter/material.dart';

import 'activity_widget_layout_constructor.dart';
import 'layout_activity.dart';

class ControlActivityCommandPanel extends StatelessWidget {
  final List<ActivityCommand> commands;
  final Function(String) onCommandSelected;

  const ControlActivityCommandPanel({required this.commands, required this.onCommandSelected, super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    buttons.add(const SizedBox(width: LayoutConstants.iconSize + LayoutConstants.rowSpacing));
    _constructButtons(commands, onCommandSelected, buttons);
    return Row(children: buttons);
  }

  void _constructButtons(List<ActivityCommand> commands, Function(String) onCommandSelected, List<Widget> buttons) {
    for (ActivityCommand command in commands) {
      buttons.add(ElevatedButton.icon(
          icon: Icon(command.icon),
          label: Text(command.label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Set background color to red
            foregroundColor: Colors.white, // This sets the text color for the button's label
          ),
          onPressed: () {
            onCommandSelected(command.id);
          }));
      buttons.add(const SizedBox(width: LayoutConstants.rowSpacing));
    }
  }
}
