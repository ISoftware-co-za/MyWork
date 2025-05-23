part of dialog_work;

class _DialogWorkControlColumnBoolean extends StatefulWidget {
  //#region PROPERTIES
  final TableColumnBoolean column;

  //#endregion

  //#region CONSTRUCTION
  const _DialogWorkControlColumnBoolean({required this.column});

  @override
  State<_DialogWorkControlColumnBoolean> createState() => _DialogWorkControlColumnBooleanState();

//#endregion
}

class _DialogWorkControlColumnBooleanState extends State<_DialogWorkControlColumnBoolean> {
//#region BUILD

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.column.label),
      Checkbox(
          tristate: true,
          value: widget.column.filterValue.value,
          onChanged: (value) {
            setState(() {
              widget.column.filterValue.value = value;
              ;
            });
          })
    ]);
  }

//#endregion
}