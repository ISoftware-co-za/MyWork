import 'package:flutter/foundation.dart';

import 'activity.dart';

class ActivityList extends ChangeNotifier {
  final List<Activity> items = [];

  void add(Activity activity) {
    items.add(activity);
    notifyListeners();
  }

  void remove(Activity activity) {
    items.remove(activity);
    notifyListeners();
  }
}