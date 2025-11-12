import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/model/activity_note.dart';
import 'package:client_interfaces1/tabs/page_activities/controller/controller_activity.dart';
import 'package:flutter/material.dart';

import '../../../model/activity_note_list.dart';
import '../../../theme/theme_extension_spacing.dart';
import '../../../ui_toolkit/control_icon_button_large.dart';
import '../../../ui_toolkit/form/form.dart';
import 'control_note.dart';

class LayoutActivityNotes extends StatefulWidget {
  LayoutActivityNotes({
    required ControllerActivity controller,
    required ThemeExtensionSpacing spacingTheme,
    super.key,
  }) : _controller = controller,
       _spacingTheme = spacingTheme {
    _notes = _controller.selectedActivity.value!.notes;
  }

  @override
  State<LayoutActivityNotes> createState() => _LayoutActivityNotesState();

  late final ActivityNoteList _notes;
  final ThemeExtensionSpacing _spacingTheme;
  final ControllerActivity _controller;
}

class _LayoutActivityNotesState extends State<LayoutActivityNotes> {
  @override
  Widget build(BuildContext context) {
    ThemeExtensionForm formTheme = Theme.of(
      context,
    ).extension<ThemeExtensionForm>()!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isMouseover = true),
      onExit: (_) => setState(() => _isMouseover = false),
      child: Padding(
        padding: widget._spacingTheme.edgeInsetsWide,
        child: ListenableBuilder(
          listenable: widget._controller.selectedActivity.value!.notes,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _createChildWidgets(formTheme),
            );
          }
        ),
      ),
    );
  }

  List<Widget> _createChildWidgets(ThemeExtensionForm formTheme) {
    List<Widget> children = [];
    children.add(Text('Notes', style: formTheme.valueStyleEmphasised));
    children.add(SizedBox(height: widget._spacingTheme.verticalSpacing));
    for (ActivityNote note in widget._notes.items) {
      children.add(ControlNote(note: note, formTheme: formTheme, onDeleteNote: widget._controller.onDeleteNote));
    }
    if (_isMouseover) {
      children.add(
        Center(
          child: ControlIconButtonLarge(
            icon: Icon(Icons.add),
            onPressed: () {
              Executor.runCommand(
                'ControlIconButtonLarge.add',
                'LayoutPageActivities',
                    () => widget._controller.onNoteAdded(),
              );
            },
          ),
        ),
      );
    }
    return children;
  }

  bool _isMouseover = false;
}
