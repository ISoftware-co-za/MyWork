import 'package:client_interfaces1/state/property_changed_registry.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'facade_work.dart';
import 'state_work.dart';

enum ControllerWorkState { noWork, newWork, existingWork }

class ControllerWork {
  //#region PROPERTIES

  ValueNotifier<StateWork?> selectedWork = ValueNotifier<StateWork?>(null);
  bool get hasWork => selectedWork.value != null;
  bool get hasExistingWork => _workState == ControllerWorkState.existingWork;

  //#endregion

  //#region EVENT HANDLERS

  void onNewWork() {
    if (_saveExistingWork()) {
      selectedWork.value = StateWork();
      _workState = ControllerWorkState.newWork;
    }
  }

  void onWorkSelected(StateWork work) {
    if (_saveExistingWork()) {
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

  bool onSave() {
    assert(selectedWork.value != null);
    if (PropertyChangedRegistry.hasChanges.value == false) {
      return true;
    }

    if (PropertyChangedRegistry.validateChanges()) {
      var facade = GetIt.instance<FacadeWork>();
      if (_workState == ControllerWorkState.newWork) {
        facade.define(item: selectedWork.value!);
        _workState = ControllerWorkState.existingWork;
      } else {
        facade.update(item: selectedWork.value!);
      }
      PropertyChangedRegistry.acceptChanges();
      return true;
    }
    return false;
  }

  void onCancel() {
    PropertyChangedRegistry.rejectChanges();
  }

  //#endregion

  //#region PRIVATE METHODS

  bool _saveExistingWork() {
    bool mustCreateNewWork = true;
    if (hasWork) {
      mustCreateNewWork = onSave();
    }
    return mustCreateNewWork;
  }

  //#endregion

  //#region FIELDS

  ControllerWorkState _workState = ControllerWorkState.noWork;

  //#endregion
}
