import 'package:flutter/material.dart';

import '../model/work.dart';
import '../tabs/page_activities/controller/controller_activity_list.dart';
import 'controller_work.dart';
import 'coordinator_base.dart';

class CoordinatorWorkActivityList extends CoordinatorBase {
  //# region PROPERTIES

  final ControllerWork workController;
  final ControllerActivityList activityListController;
  final TabController tabController;

  //#endregion

  //#region CONSTRUCTION

  CoordinatorWorkActivityList(
    this.workController,
    this.activityListController,
    this.tabController
  );

  //#endregion

  //#region EVENT HANDLERS

  Future onNewWork() async {
    if (await _saveUnsavedEdits() == false) {
      return;
    }
    tabController.index = 0;
    workController.newWork();
    activityListController.selectWork(workController.selectedWork.value);
    activityListController.emptyActivityList();
  }

  Future onWorkSelected(Work work) async {
    if (await _saveUnsavedEdits() == false) {
      return;
    }
    await work.loadDetails();
    workController.selectWork(work);
    activityListController.selectWork(work);
    await activityListController.loadActivitiesIfRequired();
  }

  Future onDeleteWork() async {
    await workController.deleteWork();
    activityListController.emptyActivityList();
  }

  //#endregion

  //#region PRIVATE METHODS

  Future<bool> _saveUnsavedEdits() async {
    if (await activityListController.saveActivityIfRequired() == false) {
      return false;
    }
    if (await workController.saveActivityIfRequired() == false) {
      return false;
    }
    return true;
  }

  //#endregion
}
