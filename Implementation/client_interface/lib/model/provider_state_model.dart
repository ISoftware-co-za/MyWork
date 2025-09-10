import 'package:flutter/widgets.dart';

import 'state_model.dart';

class ProviderStateModel extends InheritedWidget {
  final StateModel state;

  ProviderStateModel({
    required this.state,
    required super.child,
    super.key,
  });

  static ProviderStateModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProviderStateModel>();
  }

  @override
  bool updateShouldNotify(ProviderStateModel oldWidget) => false;
}
