import 'package:flutter/foundation.dart';

import '../state/data_source_work.dart';
import '../state/handler_on_work_selected.dart' show HandlerOnWorkSelected;
import '../state/state_work.dart';
import 'table_columns.dart';

class FilterWork {
  final ValueNotifier<List<WorkSummary>> filteredWorkItems =
      ValueNotifier<List<WorkSummary>>([]);

  FilterWork(TableColumnCollection columns, DataSourceWork workDataSource,
      HandlerOnWorkSelected handlerOnWorkSelected)
      : _dataSource = workDataSource,
        _handlerOnWorkSelected = handlerOnWorkSelected {
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

  Future onWorkSelected(WorkSummary selectedWorkSummary) async {
    await _handlerOnWorkSelected.onWorkSelected(selectedWorkSummary);
  }

  void _onFilterChanged() {
    List<WorkSummary> filteredItems = [];
    String? lowercaseName = _name!.filterValue.value.toLowerCase();
    String? lowercaseReference = _reference!.filterValue.value.toLowerCase();
    List<String> selectedTypes =
        _type!.filterValue.map((workType) => workType.toLowerCase()).toList();

    for (WorkSummary workItem in _dataSource.workItems) {
      if (workItem.isMatch(lowercaseName, lowercaseReference, selectedTypes,
          _archived!.filterValue.value)) {
        filteredItems.add(workItem);
      }
    }
    filteredWorkItems.value = filteredItems;
  }

  TableColumnList? _type;
  TableColumnText? _name;
  TableColumnText? _reference;
  TableColumnBoolean? _archived;
  final DataSourceWork _dataSource;
  final HandlerOnWorkSelected _handlerOnWorkSelected;
}
