import 'package:flutter/material.dart';

import '../model/work.dart';
import '../tabs/page_activities/controller/controller_activity_list.dart';
import 'controller_work.dart';
import 'coordinator_base.dart';

class CoordinatorWorkActivityList extends CoordinatorBase {
  final ControllerWork workController;
  final ControllerActivityList activityController;
  final TabController tabController;

  CoordinatorWorkActivityList(
    this.workController,
    this.activityController,
    this.tabController
  );

  Future onNewWork() async {
    if (await _saveUnsavedEdits() == false) {
      return;
    }
    tabController.index = 0;
    workController.newWork();
    activityController.selectWork(workController.selectedWork.value);
    activityController.emptyActivityList();
  }

  Future onWorkSelected(Work work) async {
    if (await _saveUnsavedEdits() == false) {
      return;
    }
    await work.loadDetails();
    workController.selectWork(work);
    activityController.selectWork(work);
    await activityController.loadActivitiesIfRequired();
  }

  Future onDeleteWork() async {
    await workController.deleteWork();
    activityController.emptyActivityList();
  }

  Future<bool> _saveUnsavedEdits() async {
    if (await activityController.saveActivityIfRequired() == false) {
      return false;
    }
    if (await workController.saveActivityIfRequired() == false) {
      return false;
    }
    return true;
  }
}
