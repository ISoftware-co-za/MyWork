import 'package:flutter/foundation.dart';

import 'column_base.dart';

class ColumnText extends ColumnBase {
  final ValueNotifier<String> filterValue = ValueNotifier<String>('');

  ColumnText(
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
