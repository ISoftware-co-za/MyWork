part of form;

class ControlFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  final bool editable;

  const ControlFormField({
    required this.label,
    required this.property,
    required this.editable,
    super.key,
  });

  @override
  State<ControlFormField> createState() => _ControlFormFieldState();
}

class _ControlFormFieldState extends State<ControlFormField> {
  @override
  void initState() {
    super.initState();
    // _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_ControlFormFieldState - "${widget.property.value}"');
    _controller = TextEditingController(text: widget.property.value);
    debugPrint('--> 2');
    ThemeData? themeData = Theme.of(context);
    debugPrint('--> 3');
    ThemeForm? theme = themeData.extension<ThemeForm>();
    if (theme == null) {
      debugPrint('--> 3.1');
      throw Exception('ThemeForm not found in ThemeData');
    }
    debugPrint('--> 4');
    var children = <Widget>[Text(widget.label, style: theme!.labelStyle)];
    debugPrint('--> 5');

    if (widget.editable ||
        widget.property.isChanged ||
        !widget.property.isValid) {
      debugPrint('--> 6');
      children.add(_createUpdateField(theme));
    } else {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
        child: Text(widget.property.valueAsString, style: theme.valueStyle),
      ));
      debugPrint('--> 7');
    }
    if (!widget.property.isValid) {
      children.add(Text(widget.property.invalidMessage!,
          style: theme.valueStyle.copyWith(color: Colors.red)));
      debugPrint('--> 8');
    }
    debugPrint('--> 9');
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children);
  }

  TextField _createUpdateField(ThemeForm theme) {
    return TextField(
        controller: _controller,
        // focusNode: _focusNode,
        onChanged: (value) {
          widget.property.value = value;
        },
        style: (widget.property.isValid)
            ? theme.valueStyle
            : theme.valueStyleError,
        decoration: (widget.property.isValid)
            ? ((widget.property.isChanged)
                ? theme.textFieldDecorationChanged
                : theme.textFieldDecoration)
            : theme.textFieldDecorationError);
  }

  late TextEditingController _controller;
  // final FocusNode _focusNode = FocusNode();
}
