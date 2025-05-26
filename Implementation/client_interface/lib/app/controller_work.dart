import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/property_changed_registry.dart';
import '../model/work_list.dart';
import '../model/work.dart';

enum ControllerWorkState { noWork, newWork, existingWork }

class ControllerWork  {
  //#region PROPERTIES

  final WorkList workList = WorkList();
  ValueListenable<Work?> get selectedWork => _selectedWork;
  bool get hasWork => selectedWork.value != null;
  bool get hasExistingWork => hasWork && !selectedWork.value!.isNew;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);

  //#endregion

  //#region CONSTRUCTION

  Future initialise() async {
    await workList.obtain();
  }

  //#endregion

  //#region EVENT HANDLERS

  Future onNewWork() async {
    if (!hasWork || await onSave()) {
      _selectedWork.value = new Work.create();
    }
  }

  Future onWorkSelected(Work work) async {
    if (!hasWork || await onSave()) {
      await work.loadDetails();
      _selectedWork.value = work;
    }
  }

  Future onWorkDelete() async {
    assert(selectedWork.value != null);
    selectedWork.value!.delete();
    workList.delete(selectedWork.value!);
    _selectedWork.value = null;
  }

  Future<bool> onSave() async {
    assert(selectedWork.value != null);

    if (selectedWork.value!.validate()) {
      isSaving.value = true;
      try {
        if (selectedWork.value!.isNew) {
          await selectedWork.value!.define();
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

  //#endregion

  //#region PRIVATE METHODS

  /*
  Future<bool> _saveExistingWork() async {
    bool mustCreateNewWork = true;
    if (hasWork) {
      mustCreateNewWork = await onSave();
    }
    return mustCreateNewWork;
  }
  */

  //#endregion

  final _selectedWork = ValueNotifier<Work?>(null);
}
