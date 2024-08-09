import 'package:flutter/widgets.dart';

import 'state_application.dart';

class ProviderStateApplication extends InheritedWidget {
  final StateApplication state;

  const ProviderStateApplication({
    required this.state,
    required super.child,
    super.key,
  });

  static ProviderStateApplication? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProviderStateApplication>();
  }

  @override
  bool updateShouldNotify(ProviderStateApplication oldWidget) {
    return oldWidget.state.selectedWork != state.selectedWork;
  }
}