import 'package:flutter/widgets.dart';

import '../dialog_work/controller/controller_dialog_work.dart';
import 'controller_base.dart';
import 'coordinator_base.dart';

class ProviderStateApplicationLazyLoadedController {
  ControllerDialogWork? workDialogController;
}

class ProviderStateApplication extends InheritedWidget {

  ProviderStateApplication({
    required super.child,
    super.key,
  });

  static ProviderStateApplication? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ProviderStateApplication>();
  }

  void registerController<T extends ControllerBase>(T controller) {
    _controllerMap[T] = controller;
  }

  T? getController<T extends ControllerBase>() {
    return _controllerMap[T] as T?;
  }

  void registerCoordinator<T extends CoordinatorBase>(T coordinator) {
    _coordinatorMap[T] = coordinator;
  }

  T? getCoordinator<T extends CoordinatorBase>() {
    return _coordinatorMap[T] as T?;
  }

  @override
  bool updateShouldNotify(ProviderStateApplication oldWidget) => false;

  final Map<Type, ControllerBase> _controllerMap = {};
  final Map<Type, CoordinatorBase> _coordinatorMap = {};
}

