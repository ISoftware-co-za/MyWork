import 'package:flutter/material.dart';

import '../app/provider_state_application.dart';
import '../dialog_work/controller_dialog_work.dart';
import '../dialog_work/dialog_work_layout.dart';
import 'control_button_add_work.dart';
import 'control_button_select_work.dart';

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
    ProviderStateApplication stateProvider = ProviderStateApplication.of(context)!;
    ControllerDialogWork? controller = stateProvider.lazyLoadControllers.workDialogController;
    if (controller == null) {
      controller = stateProvider.lazyLoadControllers.workDialogController = ControllerDialogWork(
          stateProvider.workTypesController, stateProvider.workController, stateProvider.notificationController);
    }
    controller.showWorkList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogWorkLayout(
              controller: controller!, workTypes: stateProvider.workTypesController.workTypes!);
        });
  }

  bool _isMouseOver = false;
}
