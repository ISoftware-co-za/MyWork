part of 'form.dart';

class ControlFormField extends StatelessWidget {
  final String label;
  final StateProperty property;
  final bool editable;

  ControlFormField({
    required this.label,
    required this.property,
    required this.editable,
    super.key,
  }) {
    _controller = TextEditingController(text: property.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData? themeData = Theme.of(context);
    FormTheme? theme = themeData.extension<FormTheme>();
    for (var entry in themeData.extensions.entries) {
      if (entry.value is IconButtonAcceptTheme) {
      } else if (entry.value is FormTheme) {
        theme = entry.value as FormTheme;
      }
    }

    return ListenableBuilder(
      listenable: property,
      builder: (context, child) {
        var children = <Widget>[Text(label, style: theme!.labelStyle)];

        if (editable || property.isChanged || !property.isValid) {
          children.add(_createUpdateField(theme));
        } else {
          children.add(_createReadOnlyField(theme));
        }
        if (!property.isValid) {
          children.add(_createErrorMessage(theme));
        }
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children);
      },
    );
  }

  Padding _createReadOnlyField(FormTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
      child: Text(property.valueAsString, style: theme.valueStyle),
    );
  }

  TextField _createUpdateField(FormTheme theme) {
    return TextField(
        controller: _controller,
        // focusNode: _focusNode,
        onChanged: (value) {
          property.value = value;
        },
        style: (property.isValid) ? theme.valueStyle : theme.valueStyleError,
        decoration: (property.isValid)
            ? ((property.isChanged)
                ? theme.textFieldDecorationChanged
                : theme.textFieldDecoration)
            : theme.textFieldDecorationError);
  }

  Text _createErrorMessage(FormTheme theme) {
    return Text(property.invalidMessage!,
        style: theme.valueStyle.copyWith(color: Colors.red));
  }

  late final TextEditingController _controller;
}
