import 'package:client_interfaces1/model/activity_list.dart';
import 'package:flutter/foundation.dart';

import '../../../controller/controller_base.dart';
import '../../../model/activity.dart';
import '../../../model/model_property_change_context.dart';
import '../../../model/person_list.dart';
import '../../../model/work.dart';

class ControllerActivityList extends ControllerBase {
  //#region PROPERTIES

  final ValueNotifier<ActivityList?> activityList =
      ValueNotifier<ActivityList?>(null);
  final ModelPropertyChangeContext modelPropertyContext = ModelPropertyChangeContext(
    name: 'ActivityList',
  );
  late final ValueListenable<Activity?> selectedActivity;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  //#endregion

  //#region CONSTRUCTION

  ControllerActivityList(PersonList people) : _people = people {
    selectedActivity = _selectedActivity;
  }

  //#endregion

  //#region METHODS

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

  //#endregion

  //#region EVENT HANDLERS

  Future onSelectActivity(Activity? activity) async {
    if (await saveActivityIfRequired()) {
      if (_selectedActivity.value != null) {
        _selectedActivity.value!.state.removeListener(onCurrentActivityStateChanged);
      }
      _selectedActivity.value = activity;
      if (_selectedActivity.value != null) {
        _selectedActivity.value!.state.addListener(onCurrentActivityStateChanged);
      }
    }
  }

  Future onCurrentActivityStateChanged() async {
    if (_selectedActivity.value != null && _selectedActivity.value!.state.notifyingProperty == "value") {
      final bool hasSingleChanges = modelPropertyContext.hasChanges.value && modelPropertyContext.changeCount == 1;
      final bool isNotNew = _selectedActivity.value!.isNew == false;
      if (hasSingleChanges && isNotNew) {
        await onSave();
      }
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
    final newActivity = Activity.createNew(
      modelPropertyContext,
      _selectedWork!.id,
    );
    _selectedActivity.value = newActivity;
    activityList.value!.add(newActivity);
  }

  Future onDeleteActivity() async {
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
          await activity.create();
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

  //#endregion

  //#region FIELDS

  final ValueNotifier<Activity?> _selectedActivity = ValueNotifier<Activity?>(
    null,
  );
  final PersonList _people;
  Work? _selectedWork;

  //#endregion
}
