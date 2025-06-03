import 'package:client_interfaces1/model/work_type.dart';
import 'package:flutter/material.dart';
import 'list_item_work.dart';

class TableColumnCollection {
  final List<TableColumnBase> columns;

  TableColumnCollection(this.columns);

  T? getColumnByLabel<T>(String? label) {
    for (TableColumnBase column in columns) {
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

abstract class TableColumnBase {
  final String label;
  final int width;
  final bool relativeWidth;
  final bool isEmphasised;
  final CellValueGetter cellValueGetter;
  final ValueNotifier<bool> hasFilerValue = ValueNotifier<bool>(false);

  TableColumnBase(
      this.label, this.width, this.relativeWidth, this.isEmphasised, this.cellValueGetter);

  void resetFilter() {
    hasFilerValue.value = false;
  }
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnText extends TableColumnBase {
  final ValueNotifier<String> filterValue = ValueNotifier<String>('');

  TableColumnText(
      super.label, super.width, super.relativeWidth, super.isEmphasised, super.cellValueGetter) {
    filterValue.addListener(() {
      hasFilerValue.value = filterValue.value.isNotEmpty;
    });
  }

  @override
  void resetFilter() {
    filterValue.value = '';
    super.resetFilter();
  }
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnBoolean extends TableColumnBase {
  final ValueNotifier<bool?> filterValue = ValueNotifier<bool?>(null);

  TableColumnBoolean(
      super.label, super.width, super.relativeWidth, super.isEmphasised, super.cellValueGetter) {
    filterValue.addListener(() {
      hasFilerValue.value = filterValue.value != null;
    });
  }

  @override
  void resetFilter() {
    filterValue.value = null;
    super.resetFilter();
  }
}

//----------------------------------------------------------------------------------------------------------------------

abstract class TableColumnListItemBase {
  final String label;
  bool isSelected = false;
  TableColumnListItemBase(this.label);
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnList extends TableColumnBase {
  final List<TableColumnListItemBase> items;
  final ValueNotifier<int> selectedCount = ValueNotifier<int>(0);


  TableColumnList(super.label, super.width, super.relativeWidth, super.isEmphasised, this.items, super.cellValueGetter) {
    selectedCount.addListener(() {
      hasFilerValue.value = selectedCount.value > 0;
    });
  }

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

  @override
  void resetFilter() {
    items.forEach((item) {
      item.isSelected = false;
    });
    selectedCount.value = 0;
    super.resetFilter();
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
