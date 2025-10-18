part of dialog_work;

class _DialogWorkLayoutHeader extends StatelessWidget {
  const _DialogWorkLayoutHeader({
    required ThemeExtensionSpacing spacingTheme,
    required ThemeExtensionDialogWork dialogTheme,
    required VoidCallback onAddPressed,
  }) : _spacingTheme = spacingTheme,
       _dialogTheme = dialogTheme,
       _onAddPressed = onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _dialogTheme.dialogBaseTheme.dialogHeaderColor,
      child: Padding(
        padding: _spacingTheme.edgeInsetsNarrow,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Work',
              style: _dialogTheme.dialogBaseTheme.dialogHeaderTextStyle,
            ),
            SizedBox(width: _spacingTheme.horizontalSpacing),
            ControlIconButtonLarge(
              icon: Icon(Icons.add),
              onPressed: _onAddPressed,
            ),
            const Spacer(),
            ControlIconButtonNormal(
              icon: Icon(Icons.close),
              onPressed: () => Executor.runCommand(
                'close',
                'dialog_work',
                () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ThemeExtensionSpacing _spacingTheme;
  final ThemeExtensionDialogWork _dialogTheme;
  final VoidCallback _onAddPressed;
}
