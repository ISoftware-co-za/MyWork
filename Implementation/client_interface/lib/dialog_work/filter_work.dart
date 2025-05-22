import 'package:flutter/foundation.dart';

import 'list_item_work.dart';
import 'table_columns.dart';

class FilterWork {
  final ValueNotifier<List<ListItemWork>> filteredWorkItems =
      ValueNotifier<List<ListItemWork>>([]);

  FilterWork(TableColumnCollection columns, List<ListItemWork> workList)
      : _workList = workList {
    _type = columns.getColumnByLabel<TableColumnList>("Type");
    _name = columns.getColumnByLabel<TableColumnText>("Name");
    _reference = columns.getColumnByLabel<TableColumnText>("Reference");
    _archived = columns.getColumnByLabel<TableColumnBoolean>("Archived");

    assert(_type != null,
        "FilterWork requires the Type TableColumnList, this is not provided");
    assert(_name != null,
        "FilterWork requires the Name TableColumnText, this is not provided");
    assert(_reference != null,
        "FilterWork requires the Reference TableColumnText, this is not provided");
    assert(_archived != null,
        "FilterWork requires the Archived TableColumnBoolean, this is not provided");

    _type!.selectedCount.addListener(_onFilterChanged);
    _name!.filterValue.addListener(_onFilterChanged);
    _reference!.filterValue.addListener(_onFilterChanged);
    _archived!.filterValue.addListener(_onFilterChanged);
  }

  void _onFilterChanged() {
    List<ListItemWork> filteredItems = [];
    String? lowercaseName = _name!.filterValue.value.toLowerCase();
    String? lowercaseReference = _reference!.filterValue.value.toLowerCase();
    List<TableColumnListItemWorkType> selectedTypes = _type!.listSelectedType();
    bool? archived = _archived!.filterValue.value;

    for (ListItemWork workItem in _workList) {
      if (workItem.isMatch(lowercaseName, lowercaseReference, selectedTypes.map((e) => e.workType.lowercaseName).toList(), archived)) {
        filteredItems.add(workItem);
      }
    }
    filteredWorkItems.value = filteredItems;
  }

  TableColumnList? _type;
  TableColumnText? _name;
  TableColumnText? _reference;
  TableColumnBoolean? _archived;
  final List<ListItemWork> _workList;
}
