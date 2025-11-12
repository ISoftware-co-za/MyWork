class StateModel {
  void registerInstance<T extends Object>(T instance) {
    _modelMap[T] = instance;
  }

  T? getInstance<T>() {
    return _modelMap[T] as T?;
  }

  final Map<Type, Object> _modelMap = {};
}