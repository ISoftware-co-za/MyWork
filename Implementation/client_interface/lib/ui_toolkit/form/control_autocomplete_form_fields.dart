part of form;

abstract class AutocompleteDataSource {
  Iterable<Object> emptyList();
  Iterable<Object> listItems([String filter = '']);
  void onItemSelected(Object item);
  void onTextEntered(String text);
}

class AutocompleteTrailingAction {
  final IconData icon;
  final VoidCallback onSelected;
  AutocompleteTrailingAction(this.icon, this.onSelected);
}

class ControlAutocompleteFormField extends StatelessWidget {
  final String label;
  final ModelProperty property;
  final bool editable;
  final double? width;
  final AutocompleteDataSource dataSource;
  final AutocompleteTrailingAction? trailingAction;

  ControlAutocompleteFormField({
    required this.label,
    required this.property,
    required this.editable,
    required this.dataSource,
    this.width,
    this.trailingAction,
    super.key,
  }) {}

  @override
  Widget build(BuildContext context) {
    ThemeExtensionForm theme = Theme.of(
      context,
    ).extension<ThemeExtensionForm>()!;
    return ListenableBuilder(
      listenable: property,
      builder: (context, child) {
        var columnChildren = <Widget>[Text(label, style: theme.labelStyle)];
        var rowChildren = <Widget>[];
        if (editable || property.isChanged) {
          rowChildren.add(_createUpdateField(theme, context));
          if (trailingAction != null) {
            rowChildren.add(SizedBox(width: 4));
            rowChildren.add(
              ControlIconButton(
                trailingAction!.icon,
                onPressed: trailingAction!.onSelected,
              ),
            );
          }
          columnChildren.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: rowChildren));
        } else {
          rowChildren.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0.5, 0.5, 0),
              child: Text(property.valueAsString, style: theme.valueStyle),
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        );
      },
    );
  }

  Widget _createUpdateField(ThemeExtensionForm theme, BuildContext context) {
    return Expanded(
      child: Autocomplete<Object>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return dataSource.emptyList();
          }
          return dataSource.listItems(textEditingValue.text);
        },
        onSelected: (Object selection) {
          Executor.runCommand(
            'Autocomplete.onSelected',
            null,
            () => dataSource.onItemSelected(selection),
          );
          property.setValue(selection);
        },
        fieldViewBuilder:
            (
              BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) {
              fieldTextEditingController.text = property.valueAsString;
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                onSubmitted: (String text) => Executor.runCommand(
                  'Autocomplete.onSubmitted',
                  null,
                  () => dataSource.onTextEntered(text),
                ),
                style: (property.isValid)
                    ? theme.valueStyle
                    : theme.valueStyleError,
                decoration: (property.isValid)
                    ? ((property.isChanged)
                          ? theme.textFieldDecorationChanged
                          : theme.textFieldDecoration)
                    : theme.textFieldDecorationError,
              );
            },
        optionsViewBuilder:
            (
              BuildContext context,
              AutocompleteOnSelected<Object> onSelected,
              Iterable<Object> options,
            ) {
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
            },
      ),
    );
  }
}
