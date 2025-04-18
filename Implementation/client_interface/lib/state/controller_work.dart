import 'package:client_interfaces1/state/property_changed_registry.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'handler_on_work_selected.dart';
import 'data_source_work.dart';
import 'facade_work.dart';
import 'state_work.dart';

enum ControllerWorkState { noWork, newWork, existingWork }

class ControllerWork implements HandlerOnWorkSelected {
  //#region PROPERTIES
  final DataSourceWork workDataSource = DataSourceWork();
  final ValueNotifier<StateWork?> selectedWork =
      ValueNotifier<StateWork?>(null);
  bool get hasWork => selectedWork.value != null;
  ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  bool get hasExistingWork => _workState == ControllerWorkState.existingWork;

  //#endregion

  //#region CONSTRUCTION

  Future initialise() async {
    var workItems = await _facade.listAll();
    workDataSource.workItems = workItems;
  }

  //#endregion

  //#region EVENT HANDLERS

  Future onNewWork() async {
    if (await _saveExistingWork()) {
      selectedWork.value = new StateWork.new();
      _workState = ControllerWorkState.newWork;
    }
  }

  Future onWorkSelected(WorkSummary selectedWorkSummary) async {
    if (await _saveExistingWork()) {
      var work = StateWork.fromWorkSummary(selectedWorkSummary);
      selectedWork.value = work;
      _workState = ControllerWorkState.existingWork;
    }
  }

  Future onWorkDelete() async {
    assert(selectedWork.value != null);
    await _facade.delete(item: selectedWork.value!);
    selectedWork.value = null;
    _workState = ControllerWorkState.noWork;
  }

  Future<bool> onSave() async {
    assert(selectedWork.value != null);

    if (selectedWork.value!.validate()) {
      isSaving.value = true;
      try {
        if (_workState == ControllerWorkState.newWork) {
          await _facade.define(item: selectedWork.value!);
          _workState = ControllerWorkState.existingWork;
        } else {
          await _facade.update(item: selectedWork.value!);
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
  final FacadeWork _facade = GetIt.instance<FacadeWork>();

  //#endregion
}
