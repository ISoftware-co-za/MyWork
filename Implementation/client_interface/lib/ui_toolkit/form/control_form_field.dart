part of 'form.dart';

class ControlFormField extends StatelessWidget {
  final String label;
  final ModelProperty property;
  final bool editable;
  final int maximumLines;
  final bool noLabel;

  ControlFormField({
    required this.label,
    required this.property,
    required this.editable,
    this.maximumLines = 1,
    this.noLabel = false,
    super.key,
  }) {
    _controller = TextEditingController(text: property.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData? themeData = Theme.of(context);
    ThemeExtensionForm theme = themeData.extension<ThemeExtensionForm>()!;
    return ListenableBuilder(
        listenable: property,
        builder: (context, child) {
          var children = <Widget>[];
          if (noLabel == false) {
            children.add(Text(label, style: theme.labelStyle));
          }
          if (editable ||
              property.isChanged ||
              !property.isValid) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.fromLTRB(4, 0.5, 0.5, 0),
              child: Text(property.valueAsString, style: theme.valueStyle),
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
        minLines: 1,
        maxLines: maximumLines,
        onChanged: (value) {
          property.value = value;
        },
        style: (property.isValid)
            ? theme.valueStyle
            : theme.valueStyleError,
        decoration: (property.isValid)
            ? ((property.isChanged)
            ? theme.textFieldDecorationChanged
            : theme.textFieldDecoration)
            : theme.textFieldDecorationError);
  }
  late final TextEditingController _controller;
}

