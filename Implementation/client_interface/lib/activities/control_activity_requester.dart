import 'package:flutter/material.dart';

import 'control_activity_control_palette.dart';

class ControlActivityRequester extends StatefulWidget {
  final String value;
  final bool editable;
  final void Function(String?) onValueChanged;
  const ControlActivityRequester(
      {required this.value, required this.editable, required this.onValueChanged, super.key});

  @override
  State<ControlActivityRequester> createState() => _ControlActivityRequesterState();
}

class _ControlActivityRequesterState extends State<ControlActivityRequester> {
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(ControlActivityControlPalette.constructLabel('Requester'));
    if (!widget.editable) {
      widgets.add(Text(widget.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)));
    } else {
    widgets.add(Expanded(
      flex: 1,
      child: TextField(
        controller: TextEditingController(text: widget.value),
        onChanged: widget.onValueChanged,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
            hintText: 'Requester',
            filled: true,
            fillColor: Color.fromARGB(255, 245, 245, 245),
            isCollapsed: true,
            contentPadding: EdgeInsets.all(4),
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
      ),
    )); }
    return Row(mainAxisSize: MainAxisSize.max, children: widgets);
  }
}
