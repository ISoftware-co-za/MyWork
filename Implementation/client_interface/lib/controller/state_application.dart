import 'controller_base.dart';
import 'coordinator_base.dart';

class StateApplication {
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

  final Map<Type, ControllerBase> _controllerMap = {};
  final Map<Type, CoordinatorBase> _coordinatorMap = {};
}