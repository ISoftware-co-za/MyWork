
import 'package:flutter/foundation.dart';

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

  Future SelectWork(Work work) async {
      _selectedWork.value = work;
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
          await selectedWork.value!.save();
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

  final _selectedWork = ValueNotifier<Work?>(null);
}
