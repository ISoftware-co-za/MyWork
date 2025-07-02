import 'package:flutter/foundation.dart';

import 'list_item_work.dart';


typedef CellValueGetter = dynamic Function(ListItemWork);

abstract class ColumnBase {
  final String label;
  final int width;
  final bool relativeWidth;
  final bool isEmphasised;
  final CellValueGetter cellValueGetter;
  final ValueNotifier<bool> hasFilerValue = ValueNotifier<bool>(false);

  ColumnBase(this.label, this.width, this.relativeWidth, this.isEmphasised, this.cellValueGetter);

  void resetFilter() {
    hasFilerValue.value = false;
  }
}
