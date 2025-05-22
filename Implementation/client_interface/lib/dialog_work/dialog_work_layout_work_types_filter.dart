part of dialog_work;

class DialogWorkLayoutWorkTypesFilter extends StatelessWidget {
  DialogWorkLayoutWorkTypesFilter(
      {required TableColumnList column,
        required List<TableColumnListItemBase> workTypes,
        super.key})
      : _column = column,
        _workTypes = workTypes;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DialogWorkLayoutWorkTypesFilterHeader(column: _column),
      Expanded(
        child: ListView.builder(
            itemCount: _workTypes.length,
            itemBuilder: (context, index) {
              var listItem = _workTypes[index];
              return _DialogWorkControlWorkTypeListItem(
                  column: _column, listItem: listItem);
            }),
      ),
    ]);
  }

  final TableColumnList _column;
  late final List<TableColumnListItemBase> _workTypes;
}