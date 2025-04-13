part of form;

class ControlFleatherFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  final bool editable;

  const ControlFleatherFormField(
      {required this.label,
      required this.property,
      required this.editable,
      super.key});

  @override
  State<ControlFleatherFormField> createState() =>
      _ControlFleatherFormFieldState();
}

class _ControlFleatherFormFieldState extends State<ControlFleatherFormField> {
  @override
  void initState() {
    super.initState();
    ParchmentDocument document;
    if (widget.property.value == null || widget.property.value!.isEmpty) {
      document = ParchmentDocument();
    } else {
      document = ParchmentDocument.fromJson(jsonDecode(widget.property.value!));
    }
    _controller = FleatherController(document: document);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeForm theme = Theme.of(context).extension<ThemeForm>()!;
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          var children = <Widget>[Text(widget.label, style: theme.labelStyle)];
          if (widget.editable || widget.property.isChanged) {
            children.add(SizedBox(
              height: 400,
              child: Column(children: [
                FleatherToolbar.basic(controller: _controller),
                Expanded(
                  child: FleatherEditor(controller: _controller),
                )
              ]),
            ));
          } else {
            children.add(FleatherField(controller: _controller));
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children);
        });
  }

  late final FleatherController _controller;
  late final FocusNode _focusNode;
}
