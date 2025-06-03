part of dialog_work;

class _DialogWorkLayoutHeader extends StatelessWidget {
  const _DialogWorkLayoutHeader({required ThemeExtensionWorkDialog theme})
      : _theme = theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _theme.dialogHeaderColor,
      child: Padding(
        padding: EdgeInsets.all(_theme.padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Work', style: _theme.dialogHeaderTextStyle),
            SizedBox(width: _theme.horizontalSpacing),
            IconButtonLarge(icon: Icon(Icons.add),
                onPressed: () => debugPrint('Add work pressed')),
            const Spacer(),
            IconButtonLarge(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))
          ],
        ),
      ),
    );
  }

  final ThemeExtensionWorkDialog _theme;
}