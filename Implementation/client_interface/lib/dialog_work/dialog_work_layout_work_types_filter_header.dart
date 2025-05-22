part of dialog_work;

class DialogWorkLayoutWorkTypesFilterHeader extends StatelessWidget {
  const DialogWorkLayoutWorkTypesFilterHeader({required TableColumnList column, super.key})
      : _column = column;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _column.selectedCount,
              builder: (context, value, child) {
                return Text('Selected ${_column.selectedCount.value}');
              }),
        ),
        IconButtonAction(Icons.close, onPressed: () => Navigator.pop(context))
      ],
    );
  }

  final TableColumnList _column;
}