import 'package:flutter/widgets.dart';

import 'controller_work.dart';

class ProviderStateApplication extends InheritedWidget {
  final ControllerWork workController;

  const ProviderStateApplication({
    required this.workController,
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
