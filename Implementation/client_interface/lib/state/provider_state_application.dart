import 'package:client_interfaces1/dialog_work/controller_dialog_work.dart';
import 'package:client_interfaces1/state/controller_work_types.dart';
import 'package:flutter/widgets.dart';

import '../notification/controller_notifications.dart';
import 'controller_user.dart';
import 'controller_work.dart';

class ProviderStateApplicationLazyLoadedController {
  ControllerDialogWork? workDialogController;
}

class ProviderStateApplication extends InheritedWidget {
  final ControllerUser userController;
  final ControllerWork workController;
  final ControllerWorkTypes workTypesController;
  final ControllerNotifications notificationController;
  final ProviderStateApplicationLazyLoadedController lazyLoadControllers =
      ProviderStateApplicationLazyLoadedController();

  ProviderStateApplication({
    required this.userController,
    required this.workController,
    required this.workTypesController,
    required this.notificationController,
    required super.child,
    super.key,
  });

  static ProviderStateApplication? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ProviderStateApplication>();
  }

  @override
  bool updateShouldNotify(ProviderStateApplication oldWidget) {
    return oldWidget.workController.selectedWork.value !=
        workController.selectedWork.value;
  }
}
