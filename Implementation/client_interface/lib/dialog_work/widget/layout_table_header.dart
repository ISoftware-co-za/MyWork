part of dialog_work;

class _DialogWorkLayoutTableHeader extends StatelessWidget {
  _DialogWorkLayoutTableHeader(
      {required ControllerDialogWork controller,
      required WorkTypeList workTypes,
      required ThemeExtensionDialogWork theme})
      : _controller = controller,
        _theme = theme {
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = _createColumns();
    return Container(
      color: _theme.dialogBaseTheme.tableHeaderColor,
      padding: EdgeInsets.symmetric(horizontal: _theme.dialogBaseTheme.padding, vertical: _theme.dialogBaseTheme.verticalSpacing),
      child: Row(children: columns),
    );
  }

  List<Widget> _createColumns() {
    var columns = <Widget>[];
    for (int index = 0; index < _controller.columns.columns.length; index++) {
      var column = _controller.columns.columns[index];
      Widget columnWidget;
      if (column is ColumnText) {
        columnWidget = _DialogWorkControlColumnText(column: column, labelStyle: _theme.dialogBaseTheme.tableHeaderTextStyle);
      } else if (column is ColumnList) {
        columnWidget = _DialogWorkControlColumnList(column: column, labelStyle: _theme.dialogBaseTheme.tableHeaderTextStyle);
      } else if (column is ColumnBoolean) {
        columnWidget = _DialogWorkControlColumnBoolean(column: column, labelStyle: _theme.dialogBaseTheme.tableHeaderTextStyle);
      } else {
        throw Exception(
            'There is no Widget defined for the column ${column.runtimeType}. Please define how a this type of column should be handled in LayoutTableHeader._createColumns.');
      }

      if (index > 0) {
        columns.add(SizedBox(width: _theme.dialogBaseTheme.horizontalSpacing));
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
  final ThemeExtensionDialogWork _theme;
}
