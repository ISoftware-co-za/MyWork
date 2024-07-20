import 'package:flutter/material.dart';

class ControlActivityDescription extends StatefulWidget {
  final String value;
  final bool editable;
  final void Function(String?) onValueChanged;
  const ControlActivityDescription({required this.value, required this.editable, required this.onValueChanged, super.key});

  @override
  State<ControlActivityDescription> createState() => _ControlActivityDescriptionState();
}

class _ControlActivityDescriptionState extends State<ControlActivityDescription> {
  @override
  Widget build(BuildContext context) {
    if (!widget.editable) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        child: Text(widget.value, style: const TextStyle(fontSize: 16.6)),
      );
    } else {
      return TextField(
        controller: TextEditingController(text: widget.value),
        onChanged: widget.onValueChanged,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Description',
          filled: true,
          fillColor: Color.fromARGB(255, 245, 245, 245),
          isCollapsed: true,
          contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.zero)
        ),
      );
    }
  }
}
