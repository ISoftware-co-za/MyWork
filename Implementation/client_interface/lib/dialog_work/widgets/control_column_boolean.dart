part of dialog_work;

class _DialogWorkControlColumnBoolean extends StatelessWidget {
  final ColumnBoolean column;

  const _DialogWorkControlColumnBoolean({required this.column, required TextStyle labelStyle})
      : _labelStyle = labelStyle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: column.filterValue,
        builder: (context, value, child) {
          return ControlColumnBase(
              column: column,
              labelStyle: _labelStyle,
              child: Checkbox(
                tristate: true,
                fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 70, 130, 180)),
                side:BorderSide(color: Colors.white, width: 2),
                value: column.filterValue.value,
                onChanged: (value) {
                  column.filterValue.value = value;
                },
              ));
        });
  }

  final TextStyle _labelStyle;
}
