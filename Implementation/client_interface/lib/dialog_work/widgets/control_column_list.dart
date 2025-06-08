part of dialog_work;

class _DialogWorkControlColumnList extends StatelessWidget {
  _DialogWorkControlColumnList({required ColumnList column, required TextStyle labelStyle})
      : _column = column,
        _labelStyle = labelStyle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _column.selectedCount,
        builder: (context, value, child) {
          return ControlColumnBase(
            column: _column,
            labelStyle: _labelStyle,
            child: InkWell(
                child: Text(_column.selectedCount.value.toString(), textAlign: TextAlign.center, key: selectedWorkTypeCountKey, style: _labelStyle.copyWith(fontWeight: FontWeight.bold),),
                onTap: () {
                  RenderBox renderBox = selectedWorkTypeCountKey.currentContext!.findRenderObject() as RenderBox;
                  Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Stack(children: [
                          Positioned(
                            top: widgetPosition.dy,
                            left: widgetPosition.dx,
                            child: Material(
                              child: LayoutDialogWorkTypesFilter(workTypes: _column.items, column: _column),
                            ),
                          )
                        ]);
                      });
                }),
          );
        });
  }

  final GlobalKey selectedWorkTypeCountKey = GlobalKey();
  final ColumnList _column;
  final TextStyle _labelStyle;
}
