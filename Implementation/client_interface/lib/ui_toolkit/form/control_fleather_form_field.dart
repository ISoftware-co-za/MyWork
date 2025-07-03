part of form;

class ControlFleatherFormField extends StatelessWidget {
  final String label;
  final StateProperty property;
  final bool editable;

  ControlFleatherFormField({required this.label, required this.property, required this.editable, super.key}) {
    ParchmentDocument document;
    if (property.value == null || property.value!.isEmpty) {
      document = ParchmentDocument();
    } else {
      document = ParchmentDocument.fromJson(jsonDecode(property.value!));
    }
    _controller = FleatherController(document: document);
    _controller.addListener(() {
      property.value = jsonEncode(_controller.document.toJson());
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeExtensionForm theme = Theme.of(context).extension<ThemeExtensionForm>()!;
    return ListenableBuilder(
        listenable: property,
        builder: (context, child) {
          var children = <Widget>[Text(label, style: theme.labelStyle)];
          if (editable || property.isChanged) {
            children.add(SizedBox(
              height: 400,
              child: Column(children: [
                FleatherToolbar.basic(controller: _controller),
                Expanded(
                  child: Container(
                      color: property.isChanged
                          ? theme.textFieldDecorationChanged.fillColor
                          : theme.textFieldDecoration.fillColor,
                      child: FleatherEditor(controller: _controller)),
                )
              ]),
            ));
          } else {
            children.add(FleatherField(controller: _controller));
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: children);
        });
  }

  late final FleatherController _controller;
}
