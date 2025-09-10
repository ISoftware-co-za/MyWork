import 'package:client_interfaces1/controller/controller_work_types.dart';
import 'package:client_interfaces1/notification/controller_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../controller/coordinator_work_and_activity_list_loader.dart';
import '../controller/provider_state_application.dart';
import '../controller/state_application.dart';
import '../dialog_work/controller/controller_dialog_work.dart';
import '../dialog_work/widget/layout_dialog_work.dart';
import '../model/work.dart';
import '../theme/theme_extension_control_work_button.dart';
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
    StateApplication stateProvider = ProviderStateApplication.of(context)!.state;

    ControllerDialogWork? controller = stateProvider.getController<ControllerDialogWork>();
    CoordinatorWorkActivityListLoader coordinator = stateProvider.getCoordinator<CoordinatorWorkActivityListLoader>()!;
    if (controller == null) {
      controller = ControllerDialogWork(
          stateProvider.getController<ControllerWorkTypes>()!, coordinator, stateProvider.getController<ControllerNotifications>()!);
    }
    controller.showWorkList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LayoutDialogWork(controller: controller!, workTypes: stateProvider.getController<ControllerWorkTypes>()!.workTypes!);
        });
  }

  bool _isMouseOver = false;
}
