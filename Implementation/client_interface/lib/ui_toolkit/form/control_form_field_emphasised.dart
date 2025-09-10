part of 'form.dart';

class ControlFormFieldEmphasised extends StatelessWidget {
  final String label;
  final ModelProperty property;
  final bool editable;

  ControlFormFieldEmphasised({
    required this.label,
    required this.property,
    required this.editable,
    super.key,
  }) {
    _controller = TextEditingController(text: property.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ThemeExtensionForm theme = themeData.extension<ThemeExtensionForm>()!;
    return ListenableBuilder(
        listenable: property,
        builder: (context, child) {
          var children = <Widget>[];
          if (editable ||
              property.isChanged ||
              !property.isValid) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(property.valueAsString, style: theme.valueStyleEmphasised),
            ));
          }
          if (!property.isValid) {
            children.add(Text(property.invalidMessage!,
                style: theme.invalidMessageStyle));
          }

          return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children);
        });
  }

  TextField _createUpdateField(ThemeExtensionForm theme) {
    return TextField(
        controller: _controller,
        // focusNode: _focusNode,
        onChanged: (value) {
          property.value = value;
        },
        style: (property.isValid)
            ? theme.valueStyleEmphasised
            : theme.valueStyleErrorEmphasised,
        decoration: (property.isValid)
            ? ((property.isChanged)
            ? theme.textFieldDecorationChanged
            : theme.textFieldDecoration)
            : theme.textFieldDecorationError);
  }
  late final TextEditingController _controller;
}

