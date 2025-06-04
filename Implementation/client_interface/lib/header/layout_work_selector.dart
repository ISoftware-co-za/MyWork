import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/provider_state_application.dart';
import '../dialog_work/dialog_work_controller.dart';
import '../dialog_work/dialog_work_layout.dart';
import '../model/work.dart';
import '../theme_extension_control_work_button.dart';
import 'control_button_add_work.dart';
import 'control_button_select_work.dart';

class LayoutWorkSelector extends StatefulWidget {
  const LayoutWorkSelector(
      {required ValueListenable<Work?> selectedWork,
      required ThemeExtensionControlWorkButton workButtonTheme,
      super.key})
      : _selectedWork = selectedWork,
        _workButtonTheme = workButtonTheme;

  @override
  State<LayoutWorkSelector> createState() => _LayoutWorkSelectorState();

  final ValueListenable<Work?> _selectedWork;
  final ThemeExtensionControlWorkButton _workButtonTheme;
}

class _LayoutWorkSelectorState extends State<LayoutWorkSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
      const ControlButtonAddWork(),
      SizedBox(width: widget._workButtonTheme.padding), // Add some space between buttons
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
                selectedWork: widget._selectedWork, workButtonTheme: widget._workButtonTheme, isMouseOver: _isMouseOver)),
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
          return DialogWorkLayout(controller: controller!, workTypes: stateProvider.workTypesController.workTypes!);
        });
  }

  bool _isMouseOver = false;
}
