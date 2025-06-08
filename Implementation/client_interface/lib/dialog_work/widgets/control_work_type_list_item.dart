part of dialog_work;

class _DialogWorkControlWorkTypeListItem extends StatefulWidget {
  const _DialogWorkControlWorkTypeListItem(
      {required ColumnList column,
        required ColumnListItemBase listItem, required ThemeExtensionDialogWorkTypesFilter themeExtension})
      : _column = column,
        _listItem = listItem,
  _themeExtension = themeExtension;

  @override
  State<_DialogWorkControlWorkTypeListItem> createState() => _DialogWorkControlWorkTypeListItemState();

  final ColumnList _column;
  final ColumnListItemBase _listItem;
  final ThemeExtensionDialogWorkTypesFilter _themeExtension;
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
        Text(widget._listItem.label, style: widget._themeExtension.workTypeTextStyle),
      ],
    );
  }
}