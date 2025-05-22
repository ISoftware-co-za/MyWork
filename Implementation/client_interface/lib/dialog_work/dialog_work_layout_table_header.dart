part of dialog_work;

class _DialogWorkLayoutTableHeader extends StatelessWidget {
  _DialogWorkLayoutTableHeader(
      {required ControllerDialogWork controller,
      required WorkTypeList workTypes,
      required WorkDialogTheme theme,
      super.key})
      : _controller = controller,
        _theme = theme {
    _workTypes = workTypes.workTypes.map((item) => TableColumnListItemWorkType(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = _createColumns();
    return Container(
      color: Color.fromARGB(255, 255, 240, 240),
      padding: EdgeInsets.symmetric(horizontal: _theme.padding, vertical: _theme.verticalSpacing),
      child: Row(children: columns),
    );
  }

  List<Widget> _createColumns() {
    var columns = <Widget>[];
    for (int index = 0; index < _controller.columns.columns.length; index++) {
      var column = _controller.columns.columns[index];
      Widget columnWidget;
      if (column is TableColumnText) {
        columnWidget = _DialogWorkControlColumnText(column: column);
      } else if (column is TableColumnList) {
        columnWidget = _DialogWorkControlColumnList(column: column);
      } else if (column is TableColumnBoolean) {
        columnWidget = _DialogWorkControlColumnBoolean(column: column);
      } else {
        throw Exception(
            'There is no Widget defined for the column ${column.runtimeType}. Please define how a this type of column should be handled in LayoutTableHeader._createColumns.');
      }

      if (index > 0) {
        columns.add(SizedBox(width: _theme.horizontalSpacing));
      }
      if (column.relativeWidth) {
        columns.add(Expanded(
          flex: column.width,
          child: columnWidget,
        ));
      } else {
        columns.add(SizedBox(width: column.width.toDouble(), child: columnWidget));
      }
    }
    return columns;
  }

  final ControllerDialogWork _controller;
  late final Iterable<TableColumnListItemWorkType> _workTypes;
  final WorkDialogTheme _theme;
}
