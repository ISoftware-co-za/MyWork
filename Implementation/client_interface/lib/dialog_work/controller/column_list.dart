import 'package:flutter/material.dart';

import '../../model/work_type.dart';
import 'column_base.dart';

class ColumnList extends ColumnBase {
  final List<ColumnListItemBase> items;
  final ValueNotifier<int> selectedCount = ValueNotifier<int>(0);


  ColumnList(super.label, super.width, super.relativeWidth, super.isEmphasised, this.items, super.cellValueGetter) {
    selectedCount.addListener(() {
      hasFilerValue.value = selectedCount.value > 0;
    });
  }

  void selectWorkType(ColumnListItemBase item) {
    item.isSelected = true;
    selectedCount.value += 1;
  }

  void deselectWorkType(ColumnListItemBase item) {
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

//----------------------------------------------------------------------------------------------------------------------

abstract class ColumnListItemBase {
  final String label;
  bool isSelected = false;
  ColumnListItemBase(this.label);
}

//----------------------------------------------------------------------------------------------------------------------

class ColumnListItemWorkType extends ColumnListItemBase {
  final WorkType workType;

  ColumnListItemWorkType(this.workType) : super(workType.name);

  @override
  String toString() {
    return workType.name;
  }
}