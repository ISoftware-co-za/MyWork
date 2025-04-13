part of form;

class ControlAutocompleteFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  final bool editable;
  final double? width;
  final AutocompleteFormFieldDataSource dataSource;

  ControlAutocompleteFormField(
      {required this.label,
      required this.property,
      required this.editable,
      required this.dataSource,
      this.width,
      super.key}) {
    debugPrint(
        'ControlAutocompleteFormField - ${dataSource.listItems('')}');
  }

  @override
  State<ControlAutocompleteFormField> createState() =>
      _ControlAutocompleteFormFieldState();
}

class _ControlAutocompleteFormFieldState
    extends State<ControlAutocompleteFormField> {
  @override
  Widget build(BuildContext context) {
    ThemeForm theme = Theme.of(context).extension<ThemeForm>()!;
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          var children = <Widget>[Text(widget.label, style: theme.labelStyle)];
          if (widget.editable || widget.property.isChanged) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
              child:
                  Text(widget.property.valueAsString, style: theme.valueStyle),
            ));
          }
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children);
        });
  }

  Autocomplete<Object> _createUpdateField(ThemeForm theme) {
    return Autocomplete<Object>(
        optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text == '') {
        return widget.dataSource.emptyList();
      }
      return widget.dataSource.listItems(textEditingValue.text);
    }, onSelected: (Object selection) {
      Executor.runCommand('Autocomplete.onSelected', null,
          () => widget.dataSource.onItemSelected(selection), context);
      widget.property.setValue(selection);
    }, fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
      fieldTextEditingController.text = widget.property.valueAsString;
      return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onSubmitted: (String text) => Executor.runCommandAsync(
              'Autocomplete.onSubmitted',
              null,
              () => widget.dataSource.onTextEntered(text),
              context),
          style: (widget.property.isValid)
              ? theme.valueStyle
              : theme.valueStyleError,
          decoration: (widget.property.isValid)
              ? ((widget.property.isChanged)
                  ? theme.textFieldDecorationChanged
                  : theme.textFieldDecoration)
              : theme.textFieldDecorationError);
    }, optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<Object> onSelected,
            Iterable<Object> options) {
      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: widget.width ?? 200,
          height: 400,
          child: Material(
            elevation: 4,
            child: ListView(
              children: options.map((Object option) {
                return ListTile(
                  title: Text(option.toString() ?? ''),
                  onTap: () {
                    onSelected(option);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}

//----------------------------------------------------------------------------------------------------------------------
