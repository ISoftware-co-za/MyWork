import 'package:flutter/material.dart';

class ControlActivityControlPalette {
  static Widget constructLabel(String label) {
    return Text('$label:', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200));
  }

  static List<Widget> constructDuration(bool editable, String label, String? valueInMinutes, Function(String?) onValueChanged ) {
    var widgets = <Widget>[];
    widgets.add(ControlActivityControlPalette.constructLabel(label));
    Widget rowWidget;
    if (!editable) {
      rowWidget = Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        child: Text(valueInMinutes ?? '', style: const TextStyle(fontSize: 14.6, fontWeight: FontWeight.bold)),
      );
    } else {
      rowWidget = TextField(
        controller: TextEditingController(text: valueInMinutes),
        onChanged: (value) {
          onValueChanged(value);
        },
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
            hintText: '10m, 4h, 2d etc.',
            filled: true,
            fillColor: Color.fromARGB(255, 245, 245, 245),
            isCollapsed: true,
            contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
      ); }
    widgets.add(Expanded(child: rowWidget));
    return widgets;
  }
}