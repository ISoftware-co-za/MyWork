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
    ThemeData theme3 = Theme.of(context);
    FormTheme formTheme = theme3.extension<FormTheme>()!;

    debugPrint('_ControlFormFieldState - "${property.value}"');
    debugPrint('--> 2');
    ThemeData? themeData = Theme.of(context);
    debugPrint('--> 3');
    FormTheme? theme = themeData.extension<FormTheme>();
    IconButtonAcceptTheme? theme2 = themeData.extension<IconButtonAcceptTheme>();

    for(var entry in themeData.extensions.entries) {
      if (entry.value is IconButtonAcceptTheme) {
        debugPrint('Found IconButtonAcceptTheme');
      } else if (entry.value is FormTheme) {
        theme = entry.value as FormTheme;
        debugPrint('Found ThemeFormXXX ${theme}');
      }
      debugPrint('ThemeData - ${entry.key.runtimeType.toString()} - ${entry.value} - ${entry.value.runtimeType.toString()}');
    }

    if (theme2 == null) {
      debugPrint('--> 3.1 - theme2');
      throw Exception('ThemeForm not found in ThemeData');
    }
    if (theme == null) {
      debugPrint('--> 3.1');
      throw Exception('ThemeForm not found in ThemeData');
    }
    debugPrint('--> 4');
    var children = <Widget>[Text(label, style: theme!.labelStyle)];
    debugPrint('--> 5');

    if (editable ||
        property.isChanged ||
        !property.isValid) {
      debugPrint('--> 6');
      children.add(_createUpdateField(theme));
    } else {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
        child: Text(property.valueAsString, style: theme.valueStyle),
      ));
      debugPrint('--> 7');
    }
    if (!property.isValid) {
      children.add(Text(property.invalidMessage!,
          style: theme.valueStyle.copyWith(color: Colors.red)));
      debugPrint('--> 8');
    }
    debugPrint('--> 9');
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children);
  }

  TextField _createUpdateField(FormTheme theme) {
    return TextField(
        controller: _controller,
        // focusNode: _focusNode,
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

