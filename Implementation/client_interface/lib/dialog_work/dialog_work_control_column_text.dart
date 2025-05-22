part of dialog_work;

class _DialogWorkControlColumnText extends StatelessWidget {
  _DialogWorkControlColumnText({required TableColumnText column, super.key})
      : _column = column {
    _controller = TextEditingController(text: _column.filterValue.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_column.label),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            filled: true,
            fillColor: Colors.white,
            constraints: BoxConstraints(maxHeight: 28),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.zero),
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
            _column.filterValue.value = text;
          },
        ),
      ],
    );
  }

  final TableColumnText _column;
  late final TextEditingController _controller;
}