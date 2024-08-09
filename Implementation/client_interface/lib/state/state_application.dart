import 'package:flutter/cupertino.dart';

import 'state_work.dart';

class StateApplication {
  ValueNotifier<StateWork?> selectedWork = ValueNotifier<StateWork?>(null);
}