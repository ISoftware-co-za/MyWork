import 'package:client_interfaces1/tabs/page_activities/controller/controller_activity.dart';
import 'package:client_interfaces1/tabs/page_activities/controller/controller_activity_list.dart';
import 'package:flutter/foundation.dart';

import '../model/activity.dart';
import '../model/property_changed_registry.dart';
import '../model/work_list.dart';
import '../model/work.dart';
import 'controller_base.dart';

enum ControllerWorkState { noWork, newWork, existingWork }

class ControllerWork extends ControllerBase {

  final WorkList workList = WorkList();
  ValueListenable<Work?> get selectedWork => _selectedWork;
  bool get hasWork => selectedWork.value != null;
  bool get hasExistingWork => hasWork && selectedWork.value!.isNew == false;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  Future initialise() async {
    await workList.obtain();
  }

  Future onNewWork() async {
    if (!hasWork || await onSave()) {
      _selectedWork.value = new Work.create();
    }
  }

  Future onWorkSelected(Work work) async {
    if (!hasWork || await onSave()) {
      await work.loadDetails();
      _selectedWork.value = work;
    }
  }

  Future onWorkDelete() async {
    assert(hasWork, 'There is no work selected to delete.');
    await selectedWork.value!.delete();
    workList.delete(selectedWork.value!);
    _selectedWork.value = null;
  }

  Future<bool> onSave() async {
    assert(selectedWork.value != null);

    if (selectedWork.value!.validate()) {
      isSaving.value = true;
      try {
        if (selectedWork.value!.isNew) {
          await selectedWork.value!.define();
          workList.add(selectedWork.value!);
        } else {
          await selectedWork.value!.update();
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

  /*
  Future<bool> _saveExistingWork() async {
    bool mustCreateNewWork = true;
    if (hasWork) {
      mustCreateNewWork = await onSave();
    }
    return mustCreateNewWork;
  }
  */

  final _selectedWork = ValueNotifier<Work?>(null);
}

class ActivityControllers {
  late final ControllerActivityList controllerActivityList;
  late final ControllerActivity controllerActivity;

  ActivityControllers(ValueListenable<Work?> selectedWork) {
    final selectedActivity = ValueNotifier<Activity?>(null);
    controllerActivityList = ControllerActivityList(selectedWork, selectedActivity);
    controllerActivity = ControllerActivity(selectedActivity);
  }
}
