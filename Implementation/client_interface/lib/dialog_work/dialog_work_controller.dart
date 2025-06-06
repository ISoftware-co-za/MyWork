import 'package:client_interfaces1/dialog_work/list_item_work.dart';
import 'package:client_interfaces1/dialog_work/table_columns.dart';
import 'package:client_interfaces1/notification/controller_notifications.dart';

import '../app/controller_base.dart';
import '../app/controller_work.dart';
import '../app/controller_work_types.dart';
import '../model/work.dart';
import 'filter_work.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControllerDialogWork extends ControllerBase {
  late final TableColumnCollection columns;
  late final FilterWork filter;
  final ControllerNotifications notificationsController;

  ControllerDialogWork(ControllerWorkTypes workTypesController, ControllerWork workController,
      this.notificationsController)
      : _workController = workController {
    columns = TableColumnCollection([
      TableColumnList(
          'Type',
          150,
          false,
          false,
          workTypesController.workTypes!.workTypes.map((workType) => TableColumnListItemWorkType(workType)).toList(),
          (row) => row.work.type.value?.toString()),
      TableColumnText('Name', 3, true, true, (row) => row.work.name.value),
      TableColumnText('Reference', 2, true, false, (row) => row.work.reference.value),
      TableColumnBoolean('Archived', 150, false, true, (row) => row.work.archived.value),
    ]);
    filter = FilterWork(columns);
  }

  void showWorkList() {
    final wrappedWorkList = _workController.workList.workItems.map((work) => ListItemWork(work)).toList();
    filter.showWorkList(wrappedWorkList);
  }

  Future onWorkSelected(Work selectedWork) async {
    await _workController.onWorkSelected(selectedWork);
  }

  final ControllerWork _workController;
}

//----------------------------------------------------------------------------------------------------------------------
