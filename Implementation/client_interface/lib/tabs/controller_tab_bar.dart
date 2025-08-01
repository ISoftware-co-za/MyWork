import 'package:client_interfaces1/controller/coordinator_work_and_activity_change.dart';
import 'package:flutter/material.dart';

import '../controller/controller_base.dart';
import '../controller/controller_work.dart';
import 'page_activities/controller/controller_activity_list.dart';

class ControllerTabBar extends ControllerBase {
  final CoordinatorWorkAndActivityChange coordinatorWorkAndActivityChange;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  final TabController tabController;

  ControllerTabBar(
    this.tabController,
    ControllerWork workController,
    ControllerActivityList activityListController,
  ) : _workController = workController,
      _activityListController = activityListController,
      coordinatorWorkAndActivityChange = CoordinatorWorkAndActivityChange(
        workController.modelPropertyContext,
        activityListController.modelPropertyContext,
      ) {}

  Future onAccept() async {
    isSaving.value = true;
    try {
      if (tabController.index == 0) {
        await _workController.onSave();
      } else if (tabController.index == 1) {
        await _activityListController.onSave();
      }
    } finally {
      isSaving.value = false;
    }
  }

  void onReject() {
    if (tabController.index == 0) {
      _workController.onCancel();
    } else if (tabController.index == 1) {
      _activityListController.onCancel();
    }
  }

  /*
  void onActivitySelected() {
    if (_currentlySelectedActivity != null) {
      _currentlySelectedActivity!.state.removeListener(
          onActivityStateChanged);
    }
    _currentlySelectedActivity =
        _activityListController.selectedActivity.value;
    if (_currentlySelectedActivity != null) {
      _currentlySelectedActivity!.state.addListener(onActivityStateChanged);
    }
  }

  void onActivityStateChanged() async {
    if (!_currentlySelectedActivity!.isNew) {
      Executor.runCommandAsync('ControllerTabBar', null, () async {
        ModelProperty<ActivityState> state = _currentlySelectedActivity!.state;
        if (state.isChanged && state.notifyingProperty == 'value' &&
            _modelPropertyContext.changeCount == 1) {
          isSaving.value = true;
          try {
            await _currentlySelectedActivity!.update();
          }
          finally {
            _modelPropertyContext.acceptChanges();
            isSaving.value = false;
          }
        }
      });
    }
  }
  */

  // final ModelPropertyContext _modelPropertyContext;
  final ControllerWork _workController;
  final ControllerActivityList _activityListController;
  // Activity? _currentlySelectedActivity;
}
