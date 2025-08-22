import 'package:client_interfaces1/model/model_property_context.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../service/activity/list_work_activity_response.dart';
import '../service/activity/service_client_activity.dart';
import 'activity.dart';

class ActivityList extends ChangeNotifier {
  final String workId;
  final List<Activity> items = [];

  ActivityList(ModelPropertyContext modelPropertyContext, this.workId)
    : _modelPropertyContext = modelPropertyContext;

  Future loadAll() async {
    WorkActivityListResponse response = await _serviceClient.listAll(workId);
    items.clear();
    for (var item in response.items) {
      items.add(
        Activity(
          _modelPropertyContext,
          item.id,
          workId,
          item.what,
          ActivityState.fromString(item.state),
          item.why,
          item.notes,
          item.dueDate,
          null,
        ),
      );
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

  late final ModelPropertyContext _modelPropertyContext;
  final ServiceClientActivity _serviceClient =
      GetIt.instance<ServiceClientActivity>();
}
