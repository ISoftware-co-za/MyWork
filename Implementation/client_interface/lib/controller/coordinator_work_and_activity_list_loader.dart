import '../model/work.dart';
import '../tabs/page_activities/controller/controller_activity_list.dart';
import 'controller_work.dart';
import 'coordinator_base.dart';

class CoordinatorWorkActivityListLoader extends CoordinatorBase {
  final ControllerWork workController;
  final ControllerActivityList activityController;

  CoordinatorWorkActivityListLoader(
    this.workController,
    this.activityController,
  );

  Future onNewWork() async {
    if (await _saveUnsavedEdits() == false) {
      return;
    }
    workController.newWork();
    activityController.emptyActivityList();
  }

  Future onWorkSelected(Work work) async {
    if (await _saveUnsavedEdits() == false) {
      return;
    }
    await work.loadDetails();
    workController.selectWork(work);
    await activityController.loadActivitiesIfRequired(work);
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
