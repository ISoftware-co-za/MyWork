part of dialog_work;

class _DialogWorkControlColumnList extends StatefulWidget {
  const _DialogWorkControlColumnList({required TableColumnList column, super.key})
      : _column = column;

  @override
  State<_DialogWorkControlColumnList> createState() => _DialogWorkControlColumnListState();

  final TableColumnList _column;
}

class _DialogWorkControlColumnListState extends State<_DialogWorkControlColumnList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget._column.label),
        InkWell(
            child: ValueListenableBuilder(
                valueListenable: widget._column.selectedCount,
                builder: (context, value, child) {
                  return Text(widget._column.selectedCount.value.toString(),
                      key: selectedWorkTypeCountKey);
                }),
            onTap: () {
              RenderBox renderBox = selectedWorkTypeCountKey.currentContext!
                  .findRenderObject() as RenderBox;
              Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
              showDialog(
                  context: context,
                  builder: (context) {
                    return Stack(children: [
                      Positioned(
                        top: widgetPosition.dy,
                        left: widgetPosition.dx,
                        width: 500,
                        height: 500,
                        child: Material(
                          child: DialogWorkLayoutWorkTypesFilter(
                              workTypes: widget._column.items, column: widget._column),
                        ),
                      )
                    ]);
                  });
            }),
      ],
    );
  }

  final GlobalKey selectedWorkTypeCountKey = GlobalKey();
}