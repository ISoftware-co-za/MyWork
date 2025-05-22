part of dialog_work;

class _DialogWorkLayoutHeader extends StatelessWidget {
  const _DialogWorkLayoutHeader({required WorkDialogTheme theme, super.key})
      : _theme = theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_theme.padding, _theme.padding,
          _theme.padding, _theme.verticalSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Work', style: _theme.headerTextStyle),
          SizedBox(width: _theme.horizontalSpacing),
          IconButtonAction(Icons.add,
              onPressed: () => debugPrint('Add work pressed')),
          const Spacer(),
          IconButtonAction(Icons.close, onPressed: () => Navigator.pop(context))
        ],
      ),
    );
  }

  final WorkDialogTheme _theme;
}