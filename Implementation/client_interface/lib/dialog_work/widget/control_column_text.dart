part of dialog_work;

class _DialogWorkControlColumnText extends StatefulWidget {
  _DialogWorkControlColumnText({required ColumnText column, required ThemeExtensionDialogBase theme})
      : _column = column,
        _theme = theme;

  @override
  State<_DialogWorkControlColumnText> createState() => _DialogWorkControlColumnTextState();

  final ColumnText _column;
  final ThemeExtensionDialogBase _theme;
}

class _DialogWorkControlColumnTextState extends State<_DialogWorkControlColumnText> {

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._column.filterValue.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget._column.filterValue,
        builder: (context, value, child) {

          if (_controller.text != value) {
            final selection = TextSelection.collapsed(offset: value.length);
            _controller.value = TextEditingValue(
              text: value,
              selection: selection,
            );
          }

          return ControlColumnBase(
              column: widget._column,
              labelStyle: widget._theme.tableHeaderTextStyle,
              child: TextField(
                decoration: widget._theme.filterInputDecoration,
                style:  widget._theme.filterTextStyle,
                controller: _controller,
                onChanged: (text) {
                  widget._column.filterValue.value = text;
                },
              ));
        });
  }

  late final TextEditingController _controller;
}
