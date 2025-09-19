import 'package:client_interfaces1/model/activity_list.dart';
import 'package:flutter/foundation.dart';

import '../../../controller/controller_base.dart';
import '../../../model/activity.dart';
import '../../../model/model_property_change_context.dart';
import '../../../model/person_list.dart';
import '../../../model/work.dart';

class ControllerActivityList extends ControllerBase {
  final ValueNotifier<ActivityList?> activityList =
      ValueNotifier<ActivityList?>(null);
  final ModelPropertyChangeContext modelPropertyContext = ModelPropertyChangeContext(
    name: 'ActivityList',
  );
  late final ValueListenable<Activity?> selectedActivity;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  ControllerActivityList(PersonList people) : _people = people {
    selectedActivity = _selectedActivity;
  }

  bool canNavigateFrom() {
    if (selectedActivity.value != null &&
        modelPropertyContext.hasChanges.value) {
      return selectedActivity.value!.validate();
    }
    return true;
  }

  void selectWork(Work? selectedWork) {
    _selectedWork = selectedWork;
  }

  void emptyActivityList() {
    activityList.value = null;
    _selectedActivity.value = null;
  }

  Future<bool> saveActivityIfRequired() async {
    if (modelPropertyContext.hasChanges.value) {
      if (await onSave() == false) {
        return false;
      }
    }
    return true;
  }

  Future onSelectActivity(Activity? activity) async {
    if (await saveActivityIfRequired()) {
      _selectedActivity.value = activity;
    }
  }

  Future onNewActivity() async {
    assert(
      _selectedWork != null,
      'There is no work selected to add an activity.',
    );

    if (_selectedActivity.value != null &&
        _selectedActivity.value!.isNew &&
        modelPropertyContext.hasChanges.value == false) {
      return;
    }
    if (modelPropertyContext.hasChanges.value) {
      if (await onSave() == false) {
        return;
      }
    }
    final newActivity = Activity.create(
      modelPropertyContext,
      _selectedWork!.id,
    );
    _selectedActivity.value = newActivity;
    activityList.value!.add(newActivity);
  }

  Future<void> onDeleteActivity() async {
    assert(_selectedActivity.value != null, 'No activity selected to delete.');
    await _selectedActivity.value!.delete();
    activityList.value!.remove(_selectedActivity.value!);
    _selectedActivity.value = null;
  }

  Future<bool> onSave() async {
    assert(_selectedActivity.value != null);
    var activity = _selectedActivity.value!;

    if (activity.validate()) {
      isSaving.value = true;
      try {
        if (activity.isNew) {
          await activity.save();
        } else {
          await activity.update();
        }
        modelPropertyContext.acceptChanges();
      } finally {
        isSaving.value = false;
      }
      return true;
    }
    return false;
  }

  void onCancel() {
    modelPropertyContext.rejectChanges();
  }

  Future loadActivitiesIfRequired() async {
    assert(
      _selectedWork != null,
      'Work must be selected to load its activities',
    );
    if (activityList.value == null ||
        _selectedWork!.id != activityList.value!.workId) {
      activityList.value = ActivityList(
        modelPropertyContext,
        _selectedWork!.id,
      );
      await activityList.value!.loadAll(_people);
    }
  }

  final ValueNotifier<Activity?> _selectedActivity = ValueNotifier<Activity?>(
    null,
  );
  final PersonList _people;
  Work? _selectedWork;
}
