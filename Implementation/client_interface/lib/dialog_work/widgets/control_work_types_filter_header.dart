part of dialog_work;

class ControlWorkTypesFilterHeader extends StatelessWidget {
  const ControlWorkTypesFilterHeader(
      {required ColumnList column, required ThemeExtensionDialogWorkTypesFilter themeExtension, super.key})
      : _column = column,
        _themeExtension = themeExtension;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _column.selectedCount,
              builder: (context, value, child) {
                return Text('Selected ${_column.selectedCount.value}',
                    style: _themeExtension.headerTextStyle);
              }),
        ),
        ControlIconButtonLarge(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))
      ],
    );
  }

  final ColumnList _column;
  final ThemeExtensionDialogWorkTypesFilter _themeExtension;
}
