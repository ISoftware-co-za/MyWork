import 'package:flutter/material.dart';
import 'properties.dart';

class ControlFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  const ControlFormField({
    required this.label,
    required this.property,
    super.key,
  });

  @override
  State<ControlFormField> createState() => _ControlFormFieldState();
}

class _ControlFormFieldState extends State<ControlFormField> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          debugPrint('ControlFormField.TextFormField');
          return TextField(
              decoration: InputDecoration(
                labelText: widget.label,
                errorText: widget.property.invalidMessage,
                labelStyle: const TextStyle(
                  color: Colors.grey, // Default label color
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Focused underline color
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2), // Focused underline color
                ),
              ),
              onChanged: (value) {
                debugPrint('_ControlFormFieldState.onChanged($value)');
                widget.property.value = value;
              });
        });
  }
}
