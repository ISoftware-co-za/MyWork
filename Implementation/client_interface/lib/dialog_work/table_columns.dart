import 'package:client_interfaces1/model/work_type.dart';
import 'package:flutter/material.dart';
import 'list_item_work.dart';

class TableColumnCollection {
  final List<TableColumn> columns;

  TableColumnCollection(this.columns);

  T? getColumnByLabel<T>(String? label) {
    for (TableColumn column in columns) {
      if (column.label == label) {
        return column as T;
      }
    }
    return null;
  }
}

//----------------------------------------------------------------------------------------------------------------------

typedef CellValueGetter = dynamic Function(ListItemWork);

//----------------------------------------------------------------------------------------------------------------------

abstract class TableColumn {
  final String label;
  final int width;
  final bool relativeWidth;
  final CellValueGetter cellValueGetter;

  const TableColumn(
      this.label, this.width, this.relativeWidth, this.cellValueGetter);
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnText extends TableColumn {
  final ValueNotifier<String> filterValue = ValueNotifier<String>('');

  TableColumnText(
      super.label, super.width, super.relativeWidth, super.cellValueGetter);
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnBoolean extends TableColumn {
  final ValueNotifier<bool?> filterValue = ValueNotifier<bool?>(null);

  TableColumnBoolean(
      super.label, super.width, super.relativeWidth, super.cellValueGetter);
}

//----------------------------------------------------------------------------------------------------------------------

abstract class TableColumnListItemBase {
  final String label;
  bool isSelected = false;
  TableColumnListItemBase(this.label);
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnList extends TableColumn {
  final List<TableColumnListItemBase> items;
  final ValueNotifier<int> selectedCount = ValueNotifier<int>(0);

  TableColumnList(super.label, super.width, super.relativeWidth, this.items, super.cellValueGetter);

  void selectWorkType(TableColumnListItemBase item) {
    item.isSelected = true;
    selectedCount.value += 1;
  }

  void deselectWorkType(TableColumnListItemBase item) {
    item.isSelected = false;
    selectedCount.value -= 1;
  }

  List<Type> listSelectedType<Type>() {
    return items.where((item) => item.isSelected).cast<Type>().toList();
  }
}

class TableColumnListItemWorkType extends TableColumnListItemBase {
  final WorkType workType;

  TableColumnListItemWorkType(this.workType) : super(workType.name);

  @override
  String toString() {
    return workType.name;
  }
}
