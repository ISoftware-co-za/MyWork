import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/model/properties.dart';
import 'package:flutter/material.dart';

import '../controller/controller_base.dart';
import '../controller/controller_work.dart';
import '../model/activity.dart';
import '../model/property_changed_registry.dart';
import 'page_activities/controller/controller_activity_list.dart';

class ControllerTabBar extends ControllerBase {

  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  final TabController tabController;

  ControllerTabBar(this.tabController, ControllerWork workController, ControllerActivityList activityListController)
      : _workController = workController,
        _activityListController = activityListController {
    _activityListController.selectedActivity.addListener(onActivitySelected);
  }

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
        StateProperty<ActivityState> state = _currentlySelectedActivity!.state;
        if (state.isChanged && state.notifyingProperty == 'value' &&
            PropertyChangedRegistry.changeCount == 1) {
          isSaving.value = true;
          try {
            await _currentlySelectedActivity!.update();
          }
          finally {
            PropertyChangedRegistry.acceptChanges();
            isSaving.value = false;
          }
        }
      });
    }
  }

  final ControllerWork _workController;
  final ControllerActivityList _activityListController;
  Activity? _currentlySelectedActivity;
}
