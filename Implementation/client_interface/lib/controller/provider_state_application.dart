import 'package:client_interfaces1/controller/controller_base.dart';
import 'package:flutter/widgets.dart';

import '../dialog_work/controller/controller_dialog_work.dart';

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

  @override
  bool updateShouldNotify(ProviderStateApplication oldWidget) => false;

  final Map<Type, ControllerBase> _controllerMap = {};
}
