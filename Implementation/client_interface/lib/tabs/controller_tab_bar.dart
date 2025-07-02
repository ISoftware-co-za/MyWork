import 'package:flutter/material.dart';

import '../controller/controller_base.dart';
import '../controller/controller_work.dart';
import 'page_activities/controller/controller_activity_list.dart';

class ControllerTabBar extends ControllerBase {

  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  final TabController tabController;

  ControllerTabBar(this.tabController, ControllerWork workController, ControllerActivityList activityListController)
      : _workController = workController,
        _activityListController = activityListController;

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

  final ControllerWork _workController;
  final ControllerActivityList _activityListController;
}
