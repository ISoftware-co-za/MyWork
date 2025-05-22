part of dialog_work;

class _DialogWorkControlWorkTypeListItem extends StatefulWidget {
  const _DialogWorkControlWorkTypeListItem(
      {required TableColumnList column,
        required TableColumnListItemBase listItem,
        super.key})
      : _column = column,
        _listItem = listItem;

  @override
  State<_DialogWorkControlWorkTypeListItem> createState() => _DialogWorkControlWorkTypeListItemState();

  final TableColumnList _column;
  final TableColumnListItemBase _listItem;
}

class _DialogWorkControlWorkTypeListItemState extends State<_DialogWorkControlWorkTypeListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget._listItem.isSelected,
            onChanged: (value) {
              setState(() {
                widget._listItem.isSelected = value!;
                if (widget._listItem.isSelected) {
                  widget._column
                      .selectWorkType(widget._listItem);
                } else {
                  widget._column
                      .deselectWorkType(widget._listItem);
                }
              });
            }),
        Text(widget._listItem.label),
      ],
    );
  }
}