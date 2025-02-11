import 'package:flutter/material.dart';

class ControlActivityTitle extends StatefulWidget {
  final String value;
  final bool editable;
  final void Function(String?) onValueChanged;
  const ControlActivityTitle({required this.value, required this.editable, required this.onValueChanged, super.key});

  @override
  State<ControlActivityTitle> createState() => _ControlActivityTitleState();
}

class _ControlActivityTitleState extends State<ControlActivityTitle> {
  @override
  Widget build(BuildContext context) {
    if (!widget.editable) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        child: Text(widget.value, style: const TextStyle(fontSize: 20.6, fontWeight: FontWeight.bold)),
      );
    } else {
      return TextField(
        controller: TextEditingController(text: widget.value),
        onChanged: widget.onValueChanged,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
            hintText: 'Title',
            filled: true,
            fillColor: Color.fromARGB(255, 245, 245, 245),
            isCollapsed: true,
            contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero))
      );
    }
  }
}
