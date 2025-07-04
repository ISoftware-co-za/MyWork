import 'package:client_interfaces1/notification/controller_notifications.dart';

import '../../controller/controller_base.dart';
import '../../controller/controller_work.dart';
import '../../controller/controller_work_types.dart';
import '../../model/work.dart';
import 'column_boolean.dart';
import 'column_collection.dart';
import 'column_list.dart';
import 'column_text.dart';
import 'filter_work.dart';
import 'list_item_work.dart';

class ControllerDialogWork extends ControllerBase {
  late final ColumnCollection columns;
  late final FilterWork filter;
  final ControllerNotifications notificationsController;

  ControllerDialogWork(
      ControllerWorkTypes workTypesController, ControllerWork workController, this.notificationsController)
      : _workController = workController {
    columns = ColumnCollection([
      ColumnList(
          'Type',
          150,
          false,
          false,
          workTypesController.workTypes!.workTypes.map((workType) => ColumnListItemWorkType(workType)).toList(),
          (row) => row.work.type.value.toString()),
      ColumnText('Name', 3, true, true, (row) => row.work.name.value),
      ColumnText('Reference', 2, true, false, (row) => row.work.reference.value),
      ColumnBoolean('Archived', 150, false, true, (row) => row.work.archived.value),
    ]);
    filter = FilterWork(columns);
  }

  void showWorkList() {
    final wrappedWorkList = _workController.workList.workItems.map((work) => ListItemWork(work)).toList();
    filter.showWorkList(wrappedWorkList);
  }

  Future onWorkSelected(Work selectedWork) async {
    await _workController.onWorkSelected(selectedWork);
    await selectedWork.activities.loadAll();
  }

  final ControllerWork _workController;
}
