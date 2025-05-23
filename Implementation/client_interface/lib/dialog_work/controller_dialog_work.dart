import 'package:client_interfaces1/dialog_work/list_item_work.dart';
import 'package:client_interfaces1/dialog_work/table_columns.dart';

import '../state/controller_work.dart';
import '../state/controller_work_types.dart';
import '../model/work.dart';
import 'filter_work.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControllerDialogWork {
  //#region PROPERTIES

  late final TableColumnCollection columns;
  late final FilterWork filter;

  //#endregion

  //#region CONSTRUCTION

  ControllerDialogWork(ControllerWorkTypes workTypesController, ControllerWork workController) : _workController = workController {
    columns = TableColumnCollection([
      TableColumnList(
          'Type', 1, true, workTypesController.workTypes!.workTypes.map((workType) => TableColumnListItemWorkType(workType)).toList(),(row) => row.work.type.value?.toString()),
      TableColumnText('Name', 3, true, (row) => row.work.name.value),
      TableColumnText('Reference', 2, true, (row) => row.work.reference.value),
      TableColumnBoolean('Archived', 80, false, (row) => row.work.archived.value),
    ]);
    final wrappedWorkList = _workController.workList.workItems.map( (work) => ListItemWork(work)).toList();
    filter = FilterWork(columns, wrappedWorkList);
  }

  //#endregion

  void onWorkSelected(Work selectedWork) {
    _workController.selectedWork.value = selectedWork;
  }

  final ControllerWork _workController;
}

//----------------------------------------------------------------------------------------------------------------------
