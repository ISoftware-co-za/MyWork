import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'properties.dart';

//----------------------------------------------------------------------------------------------------------------------

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
    _controller = TextEditingController(text: widget.property.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FormTheme theme = Theme.of(context).extension<FormTheme>()!;
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          var children = <Widget>[Text(widget.label, style: theme.labelStyle)];
          if (widget.editable || widget.property.isChanged) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
              child: Text(widget.property.value ?? '', style: theme.valueStyle)),
            );
          }
          return Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children);
        });
  }

  TextField _createUpdateField(FormTheme theme) {
    return TextField(
        controller: _controller,
        onChanged: (value) {
          widget.property.value = value;
        },
        decoration: theme.textFieldDecoration);
  }

  late TextEditingController _controller;
}

//----------------------------------------------------------------------------------------------------------------------

class ControlFleatherFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  final UpdatingIndicator? updatingIndicator;

  const ControlFleatherFormField({required this.label, required this.property, this.updatingIndicator, super.key});

  @override
  State<ControlFleatherFormField> createState() => _ControlFleatherFormFieldState();
}

class _ControlFleatherFormFieldState extends State<ControlFleatherFormField> {
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
        widget.updatingIndicator!.isFieldFocused = _focusNode.hasFocus;
    });
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
    FormTheme theme = Theme.of(context).extension<FormTheme>()!;
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          var children = <Widget>[Text(widget.label, style: theme.labelStyle)];
          if ((widget.updatingIndicator != null && widget.updatingIndicator!.isUpdating) || widget.property.isChanged) {
            children.add(SizedBox(
              height: 400,
              child: Column(children: [
                FleatherToolbar.basic(controller: _controller),
                Expanded(
                  child: FleatherEditor(controller: _controller, focusNode: _focusNode),
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
  late final FocusNode _focusNode;
}

//----------------------------------------------------------------------------------------------------------------------

class ControlAutocompleteFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  final Iterable<String> suggestions;
  final UpdatingIndicator? updatingIndicator;
  final double? width;

  const ControlAutocompleteFormField(
      {required this.label,
      required this.property,
      required this.suggestions,
      this.updatingIndicator,
      this.width,
      super.key});

  @override
  State<ControlAutocompleteFormField> createState() => _ControlAutocompleteFormFieldState();
}

class _ControlAutocompleteFormFieldState extends State<ControlAutocompleteFormField> {
  @override
  Widget build(BuildContext context) {
    FormTheme theme = Theme.of(context).extension<FormTheme>()!;
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          var children = <Widget>[Text(widget.label, style: theme.labelStyle)];
          if ((widget.updatingIndicator != null && widget.updatingIndicator!.isUpdating) || widget.property.isChanged) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
              child: Text(widget.property.value ?? '', style: theme.valueStyle),
            ));
          }
          return Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children);
        });
  }

  Autocomplete<String> _createUpdateField(FormTheme theme) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return widget.suggestions;
        }
        var matchingOptions = widget.suggestions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        }).toList();
        if (!matchingOptions.contains(textEditingValue.text)) {
          matchingOptions.insert(0, textEditingValue.text);
        }
        return matchingOptions;
      },
      onSelected: (String selection) {
        widget.property.value = selection;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        fieldFocusNode.addListener(() {
          widget.updatingIndicator!.isFieldFocused = fieldFocusNode.hasFocus;
        });
        fieldTextEditingController.text = widget.property.value ?? '';
        return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: theme.textFieldDecoration);
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: widget.width ?? 200,
            height: 400,
            child: Material(
              elevation: 4,
              child: ListView(
                children: options.map((String option) {
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      widget.updatingIndicator!.isFieldFocused = false;
                      onSelected(option);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class UpdatingIndicator {
  bool isMouseover = false;
  bool isFieldFocused = false;
  bool get isUpdating => isMouseover || isFieldFocused;
}

//----------------------------------------------------------------------------------------------------------------------

class FormTheme extends ThemeExtension<FormTheme> {

  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final InputDecoration textFieldDecoration;
  final double fleatherEditorHeight;

  const FormTheme({
    required this.labelStyle,
    required this.valueStyle,
    required this.textFieldDecoration,
    required this.fleatherEditorHeight,
  });

  @override
  ThemeExtension<FormTheme> copyWith() {
    return FormTheme(
      labelStyle: labelStyle,
      valueStyle: valueStyle,
      textFieldDecoration: textFieldDecoration,
      fleatherEditorHeight: fleatherEditorHeight,
    );
  }

  @override
  ThemeExtension<FormTheme> lerp(covariant FormTheme? other, double t) {
    if (other == null) return this;
    return FormTheme(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t)!,
      textFieldDecoration: other.textFieldDecoration,
      fleatherEditorHeight: fleatherEditorHeight + (other.fleatherEditorHeight - fleatherEditorHeight) * t,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------