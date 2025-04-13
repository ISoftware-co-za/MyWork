import 'package:client_interfaces1/dialog_work/table_columns.dart';
import 'package:client_interfaces1/state/work_type.dart';

import '../state/data_source_work.dart';
import '../state/handler_on_work_selected.dart';
import '../state/state_work.dart';
import 'filter_work.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControllerDialogWork {
  //#region PROPERTIES

  late final TableColumnCollection columns;
  late final FilterWork filter;
  late final HandlerOnWorkSelected handlerOnWorkSelected;

  //#endregion

  //#region CONSTRUCTION

  ControllerDialogWork(List<WorkType> workTypes, DataSourceWork workDataSource,
      this.handlerOnWorkSelected) {
    columns = TableColumnCollection([
      TableColumnList(
          'Type', 1, true, (context) => workTypes, (row) => row.type),
      TableColumnText('Name', 3, true, (row) => row.name),
      TableColumnText('Reference', 2, true, (row) => row.reference),
      TableColumnBoolean('Archived', 80, false, (row) => row.archived),
    ]);
    filter = FilterWork(columns, workDataSource, handlerOnWorkSelected);
  }

  //#endregion

  void onWorkSelected(WorkSummary selectedWorkSummary) {
    handlerOnWorkSelected.onWorkSelected(selectedWorkSummary);
  }
}

//----------------------------------------------------------------------------------------------------------------------
