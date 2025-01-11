import 'package:flutter/widgets.dart';

import '../notification/controller_notifications.dart';
import 'controller_work.dart';

class ProviderStateApplication extends InheritedWidget {
  final ControllerWork workController;
  final ControllerNotifications notificationController;

  const ProviderStateApplication({
    required this.workController,
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
    return oldWidget.workController.selectedWork != workController.selectedWork;
  }
}
