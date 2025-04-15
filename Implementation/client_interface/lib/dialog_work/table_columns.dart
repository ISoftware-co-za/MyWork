import 'package:flutter/material.dart';

import '../state/state_work.dart';

class TableColumnCollection {
  //#region PROPERTIES

  final List<TableColumn> columns;

  //#endregion

  //#region CONSTRUCTION

  TableColumnCollection(this.columns);

  //#endregion

  //#region METHODS

  T? getColumnByLabel<T>(String? label) {
    for (TableColumn column in columns) {
      if (column.label == label) {
        return column as T;
      }
    }
    return null;
  }

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

typedef CellValueGetter = dynamic Function(WorkSummary);

//----------------------------------------------------------------------------------------------------------------------

abstract class TableColumn {
  //#region PROPERTIES

  final String label;
  final int width;
  final bool relativeWidth;
  final CellValueGetter cellValueGetter;

  //#endregion

  //#region CONSTRUCTION

  const TableColumn(
      this.label, this.width, this.relativeWidth, this.cellValueGetter);

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnText extends TableColumn {
  //#region PROPERTIES

  final ValueNotifier<String> filterValue = ValueNotifier<String>('');

  TableColumnText(
      super.label, super.width, super.relativeWidth, super.cellValueGetter);

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnBoolean extends TableColumn {
  //#region PROPERTIES

  final ValueNotifier<bool?> filterValue = ValueNotifier<bool?>(null);

  //#endregion

  //#region CONSTRUCTION

  TableColumnBoolean(
      super.label, super.width, super.relativeWidth, super.cellValueGetter);

//#endregion
}

//----------------------------------------------------------------------------------------------------------------------

abstract class TableColumnListItemBase {
  final String label;
  final String lowercaseLabel;
  TableColumnListItemBase(this.label) : lowercaseLabel = label.toLowerCase();
}

//----------------------------------------------------------------------------------------------------------------------

abstract class lowercaseLabelProvider {
  String get lowercaseName;
}

//----------------------------------------------------------------------------------------------------------------------

typedef ListGetter = Iterable<lowercaseLabelProvider> Function(
    BuildContext context);

//----------------------------------------------------------------------------------------------------------------------

class TableColumnList extends TableColumn {
  //#region PROPERTIES

  final List<String> filterValue = [];
  final ValueNotifier<int> selectedCount = ValueNotifier<int>(0);

  //#endregion

  //#region CONSTRUCTION

  TableColumnList(super.label, super.width, super.relativeWidth,
      ListGetter listGetter, super.cellValueGetter)
      : _listGetter = listGetter;

  //#endregion

  //#region METHODS

  List<TableColumnListItem> listFilterItems(BuildContext context) {
    List<TableColumnListItem> result = [];
    Iterable<lowercaseLabelProvider> allItems = _listGetter!(context);
    for (lowercaseLabelProvider item in allItems) {
      bool isSelected = filterValue.contains(item.lowercaseName);
      result.add(TableColumnListItem(
          item.toString(), ValueNotifier<bool>(isSelected)));
    }
    return result;
  }

  void selectWorkType(String lowercaseWorkType) {
    filterValue.add(lowercaseWorkType);
    selectedCount.value = filterValue.length;
  }

  void deselectWorkType(String lowercaseworkType) {
    filterValue.remove(lowercaseworkType);
    selectedCount.value = filterValue.length;
  }

  //#endregion

  //#region FIELDS

  final ListGetter? _listGetter;

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class TableColumnListItem {
  final String label;
  final String lowercaseLabel;
  final ValueNotifier<bool> isSelected;

  TableColumnListItem(this.label, this.isSelected)
      : lowercaseLabel = label.toLowerCase();
}

//----------------------------------------------------------------------------------------------------------------------
