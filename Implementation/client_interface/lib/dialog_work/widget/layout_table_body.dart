part of dialog_work;

class _DialogWorkLayoutTableBody extends StatelessWidget {
  const _DialogWorkLayoutTableBody({
    required ControllerDialogWork controller,
    required ThemeExtensionSpacing spacingTheme,
    required ThemeExtensionDialogWork dialogTheme,
  }) : _controller = controller,
       _spacingTheme = spacingTheme,
       _dialogTheme = dialogTheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _controller.filter.filteredWorkItems,
        builder: (context, value, child) => ListView.builder(
          itemCount: _controller.filter.filteredWorkItems.value.length,
          itemBuilder: (context, index) {
            var row = _controller.filter.filteredWorkItems.value[index];
            return _DialogWorkLayoutTableRow(
              columns: _controller.columns,
              work: row,
              onWorkSummarySelectedHandler: workSelectedHandler,
              spacingTheme: _spacingTheme,
              dialogTheme: _dialogTheme,
            );
          },
        ),
      ),
    );
  }

  Future workSelectedHandler(ListItemWork selectedWork) async {
    await _controller.onWorkSelected(selectedWork.work);
  }

  final ControllerDialogWork _controller;
  final ThemeExtensionSpacing _spacingTheme;
  final ThemeExtensionDialogWork _dialogTheme;
}
