import 'package:flutter/material.dart';

import '../model/model_property.dart';
import '../theme/theme_extension_text_field.dart';

class ControlTextField extends StatelessWidget {
  final String hint;
  final ModelProperty property;
  final ThemeExtensionTextField textFieldTheme;

  ControlTextField({
    required this.hint,
    required this.property,
    required this.textFieldTheme,
    super.key,
  }) {
    _controller = TextEditingController(text: property.value);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: property,
      builder: (context, child) {
        List<Widget> children = [];
        children.add(_createUpdateField(textFieldTheme));
        if (!property.isValid) {
         children.add(Text(property.invalidMessage!, style: textFieldTheme.invalidMessageStyle));
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  TextField _createUpdateField(ThemeExtensionTextField theme) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        property.value = value;
      },
      decoration: (property.isValid)
          ? theme.textFieldDecoration.copyWith(hintText: hint)
          : theme.textFieldDecorationError.copyWith(hintText: hint)
    );
  }

  late final TextEditingController _controller;
}
