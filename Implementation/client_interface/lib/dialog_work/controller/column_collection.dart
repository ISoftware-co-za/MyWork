import 'column_base.dart';

class ColumnCollection {
  final List<ColumnBase> columns;

  ColumnCollection(this.columns);

  T? getColumnByLabel<T>(String? label) {
    for (ColumnBase column in columns) {
      if (column.label == label) {
        return column as T;
      }
    }
    return null;
  }
}