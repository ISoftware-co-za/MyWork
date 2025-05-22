part of dialog_work;

class _DialogWorkLayoutTableRow extends StatefulWidget {
  const _DialogWorkLayoutTableRow(
      {required TableColumnCollection columns,
        required ListItemWork work,
        required AsyncValueSetter<ListItemWork> onWorkSummarySelectedHandler,
        required WorkDialogTheme theme,
        super.key})
      : _columns = columns,
        _work = work,
        _onWorkSummarySelectedHandler = onWorkSummarySelectedHandler,
        _theme = theme;

  @override
  State<_DialogWorkLayoutTableRow> createState() => _DialogWorkLayoutTableRowState();

  final TableColumnCollection _columns;
  final ListItemWork _work;
  final WorkDialogTheme _theme;
  final AsyncValueSetter<ListItemWork> _onWorkSummarySelectedHandler;
}

class _DialogWorkLayoutTableRowState extends State<_DialogWorkLayoutTableRow> {
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (int index = 0; index < widget._columns.columns.length; ++index) {
      var column = widget._columns.columns[index];
      dynamic cellValue = column.cellValueGetter(widget._work);
      Widget cellWidget;
      if (cellValue is bool) {
        if (cellValue == true) {
          cellWidget = Icon(Icons.check, color: Colors.black, size: 20);
        } else {
          cellWidget = SizedBox(width: 20, height: 20);
        }
      } else if (cellValue is String) {
        cellWidget = Text(cellValue, overflow: TextOverflow.ellipsis);
      } else {
        throw Exception(
            'TableRow is not able to display a ${cellValue.runtimeType} type. Please add support for this type in TableRow.');
      }

      if (index > 0) {
        widgets.add(SizedBox(width: widget._theme.horizontalSpacing));
      }
      if (column.relativeWidth) {
        widgets.add(Expanded(
          flex: column.width,
          child: cellWidget,
        ));
      } else {
        widgets
            .add(SizedBox(width: column.width.toDouble(), child: cellWidget));
      }
    }
    return MouseRegion(
      onEnter: (event) => {
        setState(() {
          _isMouseOver = true;
        })
      },
      onExit: (event) => {
        setState(() {
          _isMouseOver = false;
        })
      },
      child: GestureDetector(
        onTap: () async {
          await Executor.runCommandAsync('_LayoutTableRow', 'DialogWork',
                  () async {
                await widget._onWorkSummarySelectedHandler(widget._work);
                Navigator.pop(context);
              }, context);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(widget._theme.padding, 0,
              widget._theme.padding, widget._theme.verticalSpacing),
          color: (_isMouseOver) ? Colors.grey[300] : Colors.white,
          child: Row(children: widgets),
        ),
      ),
    );
  }

  bool _isMouseOver = false;
}