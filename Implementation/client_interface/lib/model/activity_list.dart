import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../service/activity/list_work_activity_response.dart';
import '../service/activity/service_client_activity.dart';
import 'activity.dart';

class ActivityList extends ChangeNotifier {
  final List<Activity> items = [];

  ActivityList(String workID) : _workID = workID;

  Future loadAll() async {
    WorkActivityListResponse response = await _serviceClient.listAll(_workID);
    items.clear();
    for (var item in response.items) {
      items.add(Activity(
        item.id,
        _workID,
        item.what,
        ActivityState.fromString(item.state),
        item.why,
        item.notes,
        item.dueDate,
      ));
    }
    notifyListeners();
  }

  void add(Activity activity) {
    items.add(activity);
    notifyListeners();
  }

  void remove(Activity activity) {
    items.remove(activity);
    notifyListeners();
  }

  final ServiceClientActivity _serviceClient = GetIt.instance<ServiceClientActivity>();
  String _workID;
}
