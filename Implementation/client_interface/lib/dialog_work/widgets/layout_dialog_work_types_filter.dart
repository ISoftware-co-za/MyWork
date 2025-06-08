part of dialog_work;

class LayoutDialogWorkTypesFilter extends StatelessWidget {
  LayoutDialogWorkTypesFilter(
      {required ColumnList column,
        required List<ColumnListItemBase> workTypes,
        super.key})
      : _column = column,
        _workTypes = workTypes;

  @override
  Widget build(BuildContext context) {
    ThemeExtensionDialogWorkTypesFilter themeExtension =
        Theme.of(context).extension<ThemeExtensionDialogWorkTypesFilter>()!;
    return Container(
      color: themeExtension.backgroundColor,
      width: themeExtension.width,
      height: themeExtension.height,
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        ControlWorkTypesFilterHeader(column: _column, themeExtension: themeExtension),
        Expanded(
          child: ListView.builder(
              itemCount: _workTypes.length,
              itemBuilder: (context, index) {
                var listItem = _workTypes[index];
                return _DialogWorkControlWorkTypeListItem(
                    column: _column, listItem: listItem, themeExtension: themeExtension);
              }),
        ),
      ]),
    );
  }

  final ColumnList _column;
  late final List<ColumnListItemBase> _workTypes;
}