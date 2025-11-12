import 'package:client_interfaces1/model/activity_note.dart';
import 'package:client_interfaces1/model/model_property.dart';
import 'package:get_it/get_it.dart';

import '../service/activities/list_work_activities_response.dart';
import '../service/activities/service_client_activities.dart';
import 'activity.dart';
import 'activity_note_list.dart';
import 'model_property_change_context.dart';
import 'person_list.dart';
import 'person.dart';

class ActivityList extends ContextOwner {
  final String workId;
  final List<Activity> items = [];

  ActivityList(
    ModelPropertyChangeContext super.modelPropertyContext,
    this.workId,
  );

  Future loadAll(PersonList people) async {
    ListWorkActivitiesResponse response = await _serviceClient
        .listWorkActivities(workId);
    items.clear();
    for (var item in response.items) {
      Person? recipient;
      if (item.recipientId != null) {
        recipient = people.find(item.recipientId!);
      }
      var notes = <ActivityNote>[];
      if (item.notes != null && item.notes!.length > 0) {
        for (ActivityNoteItem noteInResponse in item.notes!) {
          notes.add(
            ActivityNote(
              context,
              noteInResponse.id,
              DateTime.parse(noteInResponse.created),
              noteInResponse.text,
            ),
          );
        }
      }
      items.add(
        Activity(
          context,
          item.id,
          workId,
          item.what,
          ActivityState.fromString(item.state),
          (item.dueDate != null) ? DateTime.parse(item.dueDate!) : null,
          recipient,
          item.why,
          item.how,
          ActivityNoteList(notes),
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
    for (final Activity activity in items) {
      if (activity.recipient.value != null &&
          ids.contains(activity.recipient.value!.id)) {
        activity.recipient.setValueWithNotification(
          null,
          ignorePropertyChanged: true,
        );
      }
    }
  }

  final ServiceClientActivities _serviceClient =
      GetIt.instance<ServiceClientActivities>();
}
