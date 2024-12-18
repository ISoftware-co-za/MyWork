import 'dart:io';

import 'package:client_interfaces1/state/property_changed_registry.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'facade_work.dart';
import 'state_work.dart';

enum ControllerWorkState { noWork, newWork, existingWork }

class ControllerWork {
  //#region PROPERTIES

  ValueNotifier<StateWork?> selectedWork = ValueNotifier<StateWork?>(null);
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  bool get hasWork => selectedWork.value != null;
  bool get hasExistingWork => _workState == ControllerWorkState.existingWork;

  //#endregion

  //#region EVENT HANDLERS

  Future<void> onNewWork() async {
    if (await _saveExistingWork()) {
      selectedWork.value = StateWork();
      _workState = ControllerWorkState.newWork;
    }
  }

  Future<void> onWorkSelected(StateWork work) async {
    if (await _saveExistingWork()) {
      selectedWork.value = work;
      _workState = ControllerWorkState.existingWork;
    }
  }

  void onWorkDelete() {
    assert(selectedWork.value != null);
    var facade = GetIt.instance<FacadeWork>();
    facade.delete(item: selectedWork.value!);
    selectedWork.value = null;
    _workState = ControllerWorkState.noWork;
  }

  Future<bool> onSave() async {
    assert(selectedWork.value != null);

    if (selectedWork.value!.validate()) {
      isSaving.value = true;
      try {
        var facade = GetIt.instance<FacadeWork>();
        if (_workState == ControllerWorkState.newWork) {
          await facade.define(item: selectedWork.value!);
          _workState = ControllerWorkState.existingWork;
        } else {
          await facade.update(item: selectedWork.value!);
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

  Future<bool> _saveExistingWork() async {
    bool mustCreateNewWork = true;
    if (hasWork) {
      mustCreateNewWork = await onSave();
    }
    return mustCreateNewWork;
  }

  //#endregion

  //#region FIELDS

  ControllerWorkState _workState = ControllerWorkState.noWork;

  //#endregion
}
