import 'package:flutter/foundation.dart';

import 'column_boolean.dart';
import 'column_list.dart';
import 'column_text.dart';
import 'column_collection.dart';
import 'list_item_work.dart';

class FilterWork {
  final ValueNotifier<List<ListItemWork>> filteredWorkItems =
      ValueNotifier<List<ListItemWork>>([]);

  FilterWork(ColumnCollection columns) {
    _type = columns.getColumnByLabel<ColumnList>("Type");
    _name = columns.getColumnByLabel<ColumnText>("Name");
    _reference = columns.getColumnByLabel<ColumnText>("Reference");
    _archived = columns.getColumnByLabel<ColumnBoolean>("Archived");

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

  void showWorkList(List<ListItemWork>? workList) {
    _workList = workList;
    _onFilterChanged();
  }

  void _onFilterChanged() {
    List<ListItemWork> filteredItems = [];
    String? lowercaseName = _name!.filterValue.value.toLowerCase();
    String? lowercaseReference = _reference!.filterValue.value.toLowerCase();
    List<ColumnListItemWorkType> selectedTypes = _type!.listSelectedType();
    bool? archived = _archived!.filterValue.value;

    for (ListItemWork workItem in _workList!) {
      if (workItem.isMatch(lowercaseName, lowercaseReference, selectedTypes.map((e) => e.workType.lowercaseName).toList(), archived)) {
        filteredItems.add(workItem);
      }
    }
    filteredWorkItems.value = filteredItems;
  }

  ColumnList? _type;
  ColumnText? _name;
  ColumnText? _reference;
  ColumnBoolean? _archived;
  List<ListItemWork>? _workList;
}
