part of dialog_work;

class _DialogWorkControlColumnText extends StatefulWidget {
  _DialogWorkControlColumnText({required TableColumnText column, required TextStyle labelStyle})
      : _column = column,
        _labelStyle = labelStyle;

  @override
  State<_DialogWorkControlColumnText> createState() => _DialogWorkControlColumnTextState();

  final TableColumnText _column;
  final TextStyle _labelStyle;
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
              labelStyle: widget._labelStyle,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  filled: true,
                  fillColor: Colors.white,
                  constraints: BoxConstraints(maxHeight: 28),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.zero),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero),
                ),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                controller: _controller,
                onChanged: (text) {
                  widget._column.filterValue.value = text;
                },
              ));
        });
  }

  late final TextEditingController _controller;
}
