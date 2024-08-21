import 'package:flutter/cupertino.dart';

import 'state_work.dart';

class ControllerWork {
  ValueNotifier<StateWork?> selectedWork = ValueNotifier<StateWork?>(null);
  bool get hasWork => selectedWork.value != null;

  void newWork() {
    selectedWork.value = StateWork();
  }
}
