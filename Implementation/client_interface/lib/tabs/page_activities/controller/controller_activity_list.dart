import 'package:client_interfaces1/model/activity_list.dart';
import 'package:flutter/foundation.dart';

import '../../../controller/controller_base.dart';
import '../../../model/activity.dart';
import '../../../model/property_changed_registry.dart';
import '../../../model/work.dart';

class ControllerActivityList extends ControllerBase {
  late final ValueNotifier<ActivityList?> activities;
  final ValueNotifier<Activity?> selectedActivity;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  ControllerActivityList(ValueListenable<Work?> selectedWork, this.selectedActivity) {
    _selectedWork = selectedWork;
    activities = ValueNotifier(selectedWork.value?.activities);

    _selectedWork.addListener(() {
      if (_selectedWork.value != null) {
        activities.value = _selectedWork.value!.activities;
      } else {
        activities.value = null;
      }
      selectedActivity.value = null;
    });
  }

  Future onNewActivity() async {
    assert(_selectedWork.value != null, 'There is no work selected to add an activity.');

    if (selectedActivity.value != null && selectedActivity.value!.isNew && PropertyChangedRegistry.hasChanges.value == false) {
      return;
    }
    if (PropertyChangedRegistry.hasChanges.value) {
      if (await onSave() == false) {
        return;
      }
    }
    final newActivity = Activity.create();
    selectedActivity.value = newActivity;
    _selectedWork.value!.activities.add(newActivity);
  }

  Future<bool> onSave() async {
    assert(selectedActivity.value != null);
    var activity = selectedActivity.value!;

    if (activity.validate()) {
      isSaving.value = true;
      try {
        if (activity.isNew) {
          await activity.save(_selectedWork.value!.id);
        } else {
          // await activity.update();
        }
        PropertyChangedRegistry.acceptChanges();
      } finally {
        isSaving.value = false;
      }
      return true;
    }
    return false;
  }

  void onCancel() {
    PropertyChangedRegistry.rejectChanges();
  }

  late final ValueListenable<Work?> _selectedWork;
}
