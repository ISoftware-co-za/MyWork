import 'package:client_interfaces1/state/provider_state_application.dart';
import 'package:client_interfaces1/state/work_type.dart';
import 'package:flutter/material.dart';

import 'control_button_add_work.dart';
import 'control_button_select_work.dart';
import '../dialog_work/dialog_work.dart';

class ControlWorkSelector extends StatefulWidget {
  final String label;
  const ControlWorkSelector({required this.label, super.key});

  @override
  State<ControlWorkSelector> createState() => _ControlWorkSelectorState();
}

class _ControlWorkSelectorState extends State<ControlWorkSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                child: ControlButtonSelectWork(
                    label: widget.label, isMouseOver: _isMouseOver)),
          )
        ]);
  }

  void _showWorkDialog(BuildContext context) {
    final workDialogController =
        ProviderStateApplication.of(context)!.workDialogController;
    final Iterable<WorkType> workTypes =
        ProviderStateApplication.of(context)!.workTypesController.workTypes;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LayoutWorkDialog(
              controller: workDialogController, workTypes: workTypes);
        });
  }

  bool _isMouseOver = false;
}
