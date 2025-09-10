part of dialog_work;

class _DialogWorkLayoutHeader extends StatelessWidget {
  const _DialogWorkLayoutHeader({required ThemeExtensionDialogWork theme})
      : _theme = theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _theme.dialogBaseTheme.dialogHeaderColor,
      child: Padding(
        padding: EdgeInsets.all(_theme.dialogBaseTheme.padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Work', style: _theme.dialogBaseTheme.dialogHeaderTextStyle),
            SizedBox(width: _theme.dialogBaseTheme.horizontalSpacing),
            ControlIconButtonLarge(icon: Icon(Icons.add),
                onPressed: () => debugPrint('Add work pressed')),
            const Spacer(),
            ControlIconButtonLarge(icon: Icon(Icons.close), onPressed: () =>
             Executor.runCommand('close', 'dialog_work', () => Navigator.pop(context)))
          ],
        ),
      ),
    );
  }

  final ThemeExtensionDialogWork _theme;
}