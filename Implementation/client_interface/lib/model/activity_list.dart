import 'package:client_interfaces1/model/model_property_change_context.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../service/activities/list_work_activities_response.dart';
import '../service/activities/service_client_activities.dart';
import 'activity.dart';
import 'person_list.dart';
import 'person.dart';

class ActivityList extends ChangeNotifier {
  final String workId;
  final List<Activity> items = [];

  ActivityList(ModelPropertyChangeContext modelPropertyContext, this.workId)
    : _modelPropertyContext = modelPropertyContext;

  Future loadAll(PersonList people) async {
    ListWorkActivitiesResponse response = await _serviceClient.listWorkActivities(workId);
    items.clear();
    for (var item in response.items) {
      Person? recipient;
      if (item.recipientId != null) {
        recipient = people.find(item.recipientId!);
      }
      items.add(
        Activity(
          _modelPropertyContext,
          item.id,
          workId,
          item.what,
          ActivityState.fromString(item.state),
          item.dueDate,
          recipient,
          item.why,
          item.how
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

  void unlinkDeletedRecipients(List<String> ids) {
    for(final Activity activity in items) {
      if (activity.recipient.value != null && ids.contains(activity.recipient.value!.id)) {
          activity.recipient.setValueWithNotification(null, ignorePropertyChanged: true);
      }
    }
  }

  late final ModelPropertyChangeContext _modelPropertyContext;
  final ServiceClientActivities _serviceClient =
      GetIt.instance<ServiceClientActivities>();
}
