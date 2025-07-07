import '../model/work.dart';
import '../tabs/page_activities/controller/controller_activity_list.dart';
import 'controller_work.dart';

class CoordinatorWorkAndActivitySelection {
  final ControllerWork workController;
  final ControllerActivityList activityController;

  CoordinatorWorkAndActivitySelection(this.workController, this.activityController);

  Future onWorkSelected(Work work) async {
    if (await activityController.saveActivityIfRequired() == false) {
      return;
    }
    if (!workController.hasWork || await workController.onSave()) {
      await work.loadDetails();
      workController.SelectWork(work);
      await  workController.selectedWork.value!.activities.loadAll();
    }
  }
}
