import 'package:client_interfaces1/model/model_property_change_context.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../service/activity/list_work_activity_response.dart';
import '../service/activity/service_client_activity.dart';
import 'activity.dart';
import 'person_list.dart';
import 'person.dart';

class ActivityList extends ChangeNotifier {
  final String workId;
  final List<Activity> items = [];

  ActivityList(ModelPropertyChangeContext modelPropertyContext, this.workId)
    : _modelPropertyContext = modelPropertyContext;

  Future loadAll(PersonList people) async {
    WorkActivityListResponse response = await _serviceClient.listAll(workId);
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
          item.notes
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
  final ServiceClientActivity _serviceClient =
      GetIt.instance<ServiceClientActivity>();
}
