import 'package:flutter/foundation.dart';

import 'column_base.dart';

class ColumnBoolean extends ColumnBase {

  final ValueNotifier<bool?> filterValue = ValueNotifier<bool?>(null);

  ColumnBoolean(
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