part of form;

abstract class AutocompleteDataSource {
  Iterable<Object> emptyList();
  Iterable<Object> listItems([String filter = '']);
  void onItemSelected(Object item);
  void onTextEntered(String text);
}

class ControlAutocompleteFormField extends StatelessWidget {
  final String label;
  final ModelProperty property;
  final bool editable;
  final double? width;
  final AutocompleteDataSource dataSource;

  ControlAutocompleteFormField(
      {required this.label,
      required this.property,
      required this.editable,
      required this.dataSource,
      this.width,
      super.key}) {
  }

  @override
  Widget build(BuildContext context) {
    ThemeExtensionForm theme = Theme.of(context).extension<ThemeExtensionForm>()!;
    return ListenableBuilder(
        listenable: property,
        builder: (context, child) {
          var children = <Widget>[Text(label, style: theme.labelStyle)];
          if (editable || property.isChanged) {
            children.add(_createUpdateField(theme, context));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.fromLTRB(4, 0.5, 0.5, 0),
              child:
              Text(property.valueAsString, style: theme.valueStyle),
            ));
          }
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children);
        });
  }

  Autocomplete<Object> _createUpdateField(ThemeExtensionForm theme, BuildContext context) {
    return Autocomplete<Object>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return dataSource.emptyList();
          }
      return dataSource.listItems(textEditingValue.text);
        }, onSelected: (Object selection) {
      Executor.runCommand('Autocomplete.onSelected', null,
              () => dataSource.onItemSelected(selection));
      property.setValue(selection);
    }, fieldViewBuilder: (BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted) {
      fieldTextEditingController.text = property.valueAsString;
      return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onSubmitted: (String text) => Executor.runCommand(
              'Autocomplete.onSubmitted',
              null,
                  () => dataSource.onTextEntered(text)),
          style: (property.isValid)
              ? theme.valueStyle
              : theme.valueStyleError,
          decoration: (property.isValid)
              ? ((property.isChanged)
              ? theme.textFieldDecorationChanged
              : theme.textFieldDecoration)
              : theme.textFieldDecorationError);
    }, optionsViewBuilder: (BuildContext context,
        AutocompleteOnSelected<Object> onSelected,
        Iterable<Object> options) {
      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width ?? 200,
          height: 400,
          child: Material(
            elevation: 4,
            child: ListView(
              children: options.map((Object option) {
                return ListTile(
                  title: Text(option.toString()),
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
