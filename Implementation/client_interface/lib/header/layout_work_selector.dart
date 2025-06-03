import 'package:flutter/material.dart';

import '../app/provider_state_application.dart';
import '../dialog_work/dialog_work_controller.dart';
import '../dialog_work/dialog_work_layout.dart';
import '../theme_extension_control_work_button.dart';
import 'control_button_add_work.dart';
import 'control_button_select_work.dart';

class LayoutWorkSelector extends StatefulWidget {
  final String label;
  final ThemeExtensionControlWorkButton workButtonTheme;
  const LayoutWorkSelector({required this.label, required this.workButtonTheme,  super.key});

  @override
  State<LayoutWorkSelector> createState() => _LayoutWorkSelectorState();
}

class _LayoutWorkSelectorState extends State<LayoutWorkSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ControlButtonAddWork(),
          SizedBox(width: widget.workButtonTheme.padding), // Add some space between buttons
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
                    label: widget.label, workButtonTheme: widget.workButtonTheme, isMouseOver: _isMouseOver)),
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
