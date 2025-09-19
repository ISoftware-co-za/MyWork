
import 'package:flutter/foundation.dart';

import '../model/model_property_change_context.dart';
import '../model/work_list.dart';
import '../model/work.dart';
import 'controller_base.dart';

enum ControllerWorkState { noWork, newWork, existingWork }

class ControllerWork extends ControllerBase {

  final ModelPropertyChangeContext modelPropertyContext = ModelPropertyChangeContext(name: 'Work');
  late final WorkList workList;
  ValueListenable<Work?> get selectedWork => _selectedWork;
  bool get hasWork => selectedWork.value != null;
  bool get hasExistingWork => hasWork && selectedWork.value!.isNew == false;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  ControllerWork() {
    workList = WorkList(modelPropertyContext);
  }

  Future initialise() async {
    await workList.obtain();
  }

  bool canNavigateFrom() {
    if (hasWork && modelPropertyContext.hasChanges.value) {
      return selectedWork.value!.validate();
    }
    return true;
  }

  Future<bool> saveActivityIfRequired() async {
    if (modelPropertyContext.hasChanges.value) {
      if (await onSave() == false) {
        return false;
      }
    }
    return true;
  }

  void newWork() {
      _selectedWork.value = new Work.create(modelPropertyContext);
  }

  void selectWork(Work work) {
      _selectedWork.value = work;
  }

  Future deleteWork() async {
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

  final _selectedWork = ValueNotifier<Work?>(null);
}
