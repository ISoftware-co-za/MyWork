part of dialog_work;

class _DialogWorkLayoutTableHeader extends StatelessWidget {
  _DialogWorkLayoutTableHeader(
      {required ControllerDialogWork controller,
      required WorkTypeList workTypes,
      required ThemeExtensionWorkDialog theme})
      : _controller = controller,
        _theme = theme {
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = _createColumns();
    return Container(
      color: _theme.tableHeaderColor,
      padding: EdgeInsets.symmetric(horizontal: _theme.padding, vertical: _theme.verticalSpacing),
      child: Row(children: columns),
    );
  }

  List<Widget> _createColumns() {
    var columns = <Widget>[];
    for (int index = 0; index < _controller.columns.columns.length; index++) {
      var column = _controller.columns.columns[index];
      Widget columnWidget;
      if (column is ColumnText) {
        columnWidget = _DialogWorkControlColumnText(column: column, labelStyle: _theme.tableHeaderTextStyle);
      } else if (column is ColumnList) {
        columnWidget = _DialogWorkControlColumnList(column: column, labelStyle: _theme.tableHeaderTextStyle);
      } else if (column is ColumnBoolean) {
        columnWidget = _DialogWorkControlColumnBoolean(column: column, labelStyle: _theme.tableHeaderTextStyle);
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
  final ThemeExtensionWorkDialog _theme;
}
