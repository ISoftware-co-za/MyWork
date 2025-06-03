part of dialog_work;

class _DialogWorkLayoutTableBody extends StatelessWidget {
  const _DialogWorkLayoutTableBody(
      {required ControllerDialogWork controller,
        required ThemeExtensionWorkDialog theme})
      : _controller = controller,
        _theme = theme;

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
                    notificationsController: _controller.notificationsController,
                    theme: _theme);
              })),
    );
  }

  Future workSelectedHandler(ListItemWork selectedWork) async {
    await _controller.onWorkSelected(selectedWork.work);
  }

  final ControllerDialogWork _controller;
  final ThemeExtensionWorkDialog _theme;
}