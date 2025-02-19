import 'dart:convert';

import 'package:client_interfaces1/state/controller_work_types.dart';
import 'package:client_interfaces1/state/state_work_type.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import '../execution/executor.dart';
import '../state/properties.dart';

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
    FormTheme theme = Theme.of(context).extension<FormTheme>()!;
    return ListenableBuilder(
        listenable: widget.property,
        builder: (context, child) {
          // ('ControlFormField.build: ${widget.property.value} (isValid = ${widget.property.isValid})');

          var children = <Widget>[Text(widget.label, style: theme.labelStyle)];
          if (widget.editable || widget.property.isChanged || !widget.property.isValid) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
              child: Text(widget.property.valueAsString, style: theme.valueStyle),
            ));
          }
          if (!widget.property.isValid) {
            children.add(Text(widget.property.invalidMessage!, style: theme.valueStyle.copyWith(color: Colors.red)));
          }
          return Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children);
        });
  }

  TextField _createUpdateField(FormTheme theme) {
    return TextField(
        controller: _controller,
        // focusNode: _focusNode,
        onChanged: (value) {
          widget.property.value = value;
        },
        style: (widget.property.isValid) ? theme.valueStyle : theme.valueStyleError,
        decoration: (widget.property.isValid)
            ? ((widget.property.isChanged) ? theme.textFieldDecorationChanged : theme.textFieldDecoration)
            : theme.textFieldDecorationError);
  }

  late TextEditingController _controller;
  // final FocusNode _focusNode = FocusNode();
}

//----------------------------------------------------------------------------------------------------------------------

class ControlFleatherFormField extends StatefulWidget {
  final String label;
  final StateProperty property;
  final bool editable;

  const ControlFleatherFormField({required this.label, required this.property, required this.editable, super.key});

  @override
  State<ControlFleatherFormField> createState() => _ControlFleatherFormFieldState();
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
    FormTheme theme = Theme.of(context).extension<FormTheme>()!;
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
  final bool editable;
  final AutocompleteDataSource dataSource;
  final double? width;

  const ControlAutocompleteFormField(
      {required this.label,
      required this.property,
      required this.editable,
      required this.dataSource,
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
          if (widget.editable || widget.property.isChanged) {
            children.add(_createUpdateField(theme));
          } else {
            children.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
              child: Text(widget.property.valueAsString, style: theme.valueStyle),
            ));
          }
          return Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children);
        });
  }

  Autocomplete<Object> _createUpdateField(FormTheme theme) {
    return Autocomplete<Object>(optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text == '') {
        return widget.dataSource.emptyList();
      }
      return widget.dataSource.listItems(textEditingValue.text);
    }, onSelected: (Object selection) {
      Executor.runCommand('Autocomplete.onSelected', null, () => widget.dataSource.onItemSelected(selection), context);
      widget.property.setValue(selection);
    }, fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
      fieldTextEditingController.text = widget.property.valueAsString;
      return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onSubmitted: (String text) => Executor.runCommandAsync('Autocomplete.onSubmitted', null, () => widget.dataSource.onTextEntered(text), context),
          style: (widget.property.isValid) ? theme.valueStyle : theme.valueStyleError,
          decoration: (widget.property.isValid)
              ? ((widget.property.isChanged) ? theme.textFieldDecorationChanged : theme.textFieldDecoration)
              : theme.textFieldDecorationError);
    }, optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Object> onSelected, Iterable<Object> options) {
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

abstract class AutocompleteDataSource {
  Iterable<Object> emptyList();
  Iterable<Object> listItems(String filter);
  void onItemSelected(Object item);
  Future<void> onTextEntered(String text);
}

//----------------------------------------------------------------------------------------------------------------------

class FormTheme extends ThemeExtension<FormTheme> {
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final TextStyle valueStyleError;
  final InputDecoration textFieldDecoration;
  final InputDecoration textFieldDecorationChanged;
  final InputDecoration textFieldDecorationError;
  final double fleatherEditorHeight;

  const FormTheme({
    required this.labelStyle,
    required this.valueStyle,
    required this.valueStyleError,
    required this.textFieldDecoration,
    required this.textFieldDecorationChanged,
    required this.textFieldDecorationError,
    required this.fleatherEditorHeight,
  });

  @override
  ThemeExtension<FormTheme> copyWith() {
    return FormTheme(
      labelStyle: labelStyle,
      valueStyle: valueStyle,
      valueStyleError: valueStyleError,
      textFieldDecoration: textFieldDecoration,
      textFieldDecorationChanged: textFieldDecorationChanged,
      textFieldDecorationError: textFieldDecorationError,
      fleatherEditorHeight: fleatherEditorHeight,
    );
  }

  @override
  ThemeExtension<FormTheme> lerp(covariant FormTheme? other, double t) {
    if (other == null) return this;
    return FormTheme(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t)!,
      valueStyleError: TextStyle.lerp(valueStyleError, other.valueStyleError, t)!,
      textFieldDecoration: other.textFieldDecoration,
      textFieldDecorationChanged: other.textFieldDecorationChanged,
      textFieldDecorationError: other.textFieldDecorationError,
      fleatherEditorHeight: fleatherEditorHeight + (other.fleatherEditorHeight - fleatherEditorHeight) * t,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------
