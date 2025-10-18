part of 'form.dart';

class ControlDateFormField extends StatefulWidget {
  final String label;
  final ModelProperty property;
  final bool editable;
  final int maximumLines;

  ControlDateFormField({
    required this.label,
    required this.property,
    required this.editable,
    this.maximumLines = 1,
    super.key,
  }) {
    String formattedDate = '';
    if (property.value != null) {
      formattedDate = formateAsCompactDate(property.value as DateTime);
    }
    _controller = TextEditingController(text: formattedDate);
    _textValueForDate = TextValueForDate(property);
  }

  @override
  State<ControlDateFormField> createState() => _ControlDateFormFieldState();

  static String formateAsCompactDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  late final TextValueForDate _textValueForDate;
  late final TextEditingController _controller;
}

class _ControlDateFormFieldState extends State<ControlDateFormField> {
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.property.validate();
      }
    });
  }

  @override
  dispose() {
    widget._controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData? themeData = Theme.of(context);
    ThemeExtensionForm? theme = themeData.extension<ThemeExtensionForm>();
    return ListenableBuilder(
      listenable: widget.property,
      builder: (context, child) {
        var children = <Widget>[Text(widget.label, style: theme!.labelStyle)];
        if (widget.editable ||
            widget.property.isChanged ||
            !widget.property.isValid) {
          children.add(_createUpdateField(context, theme));
        } else {
          children.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(7, 0.5, 0, 0.5),
              child: Text(
                widget.property.value != null
                    ? DateFormat.yMd().format(widget.property.value)
                    : '',
                style: theme.valueStyle,
              ),
            ),
          );
        }
        if (!widget.property.isValid) {
          children.add(
            Text(
              widget.property.invalidMessage!,
              style: theme.invalidMessageStyle,
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  Widget _createUpdateField(BuildContext context, ThemeExtensionForm theme) {
    InputDecoration decoration = (widget.property.isValid)
        ? ((widget.property.isChanged)
              ? theme.textFieldDecorationChanged
              : theme.textFieldDecoration)
        : theme.textFieldDecorationError;
    decoration = decoration.copyWith(hintText: DateFormat.yMd('en_ZA').pattern);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: TextField(
            controller: widget._controller,
            focusNode: _focusNode,
            minLines: 1,
            maxLines: widget.maximumLines,
            onChanged: (value) {
              setState(() {
                widget._textValueForDate.value = value;
              });
            },
            style: (widget.property.isValid)
                ? theme.valueStyle
                : theme.valueStyleError,
            decoration: decoration,
          ),
        ),
        SizedBox(width: 4),
        ControlIconButtonNormal(
          icon: Icon(Icons.date_range),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: widget.property.value as DateTime? ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            ).then((selectedDate) {
              if (selectedDate != null) {
                widget.property.value = selectedDate;
              }
            });
          },
        ),
      ],
    );
  }

  final FocusNode _focusNode = FocusNode();
}
