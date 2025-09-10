import 'package:flutter/widgets.dart';

import '../dialog_work/controller/controller_dialog_work.dart';
import 'state_application.dart';

class ProviderStateApplicationLazyLoadedController {
  ControllerDialogWork? workDialogController;
}

class ProviderStateApplication extends InheritedWidget {

  final StateApplication state;

  ProviderStateApplication({
    required this.state,
    required super.child,
    super.key,
  });

  static ProviderStateApplication? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ProviderStateApplication>();
  }


  @override
  bool updateShouldNotify(ProviderStateApplication oldWidget) => false;

}

