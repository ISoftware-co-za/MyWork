import 'package:client_interfaces1/tabs/page_details/list_item_detail.dart';
import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../state/controller_work.dart';
import '../../state/state_work.dart';
import '../../ui toolkit/control_form_fields.dart';

class LayoutDetailsForm extends StatefulWidget {
  const LayoutDetailsForm({required ControllerWork controller, super.key})
      : _controller = controller;

  @override
  State<LayoutDetailsForm> createState() => _LayoutDetailsFormState();

  final ControllerWork _controller;
}

class _LayoutDetailsFormState extends State<LayoutDetailsForm> {
  @override
  void initState() {
    super.initState();
    StateWork work = widget._controller.selectedWork.value!;
    _formFields = [
      ListItemDetail(
          label: 'Name',
          property: work.name,
          editorType: ListItemDetailEditor.text),
      ListItemDetail(
          label: 'Type',
          property: work.type,
          editorType: ListItemDetailEditor.autocomplete),
      ListItemDetail(
          label: 'Reference',
          property: work.reference,
          editorType: ListItemDetailEditor.text),
      ListItemDetail(
          label: 'Description',
          property: work.description,
          editorType: ListItemDetailEditor.parchment)
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _buildForm();
    return Container(
      key: _formKey,
      color: Colors.transparent,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }

  List<Widget> _buildForm() {
    var children = <Widget>[];
    for (var field in _formFields) {
      if (field.editorType == ListItemDetailEditor.text) {
        children.add(ControlFormField(
            label: field.label,
            property: field.property,
            editable: _updatingIndicator.isUpdating));
      } else if (field.editorType == ListItemDetailEditor.parchment) {
        children.add(ControlFleatherFormField(
            label: field.label,
            property: field.property,
            updatingIndicator: _updatingIndicator));
      } else if (field.editorType == ListItemDetailEditor.autocomplete) {
        children.add(ControlAutocompleteFormField(
            label: field.label,
            property: field.property,
            suggestions: const ['One', 'Two', 'Three'],
            updatingIndicator: _updatingIndicator));
      }
      children.add(const SizedBox(height: _columnSpacing));
    }

    if (widget._controller.hasExistingWork && _updatingIndicator.isUpdating) {
      children.add(Center(
        child: TextButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: TextButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Executor.runCommand("Delete", null, () async {
                await widget._controller.onWorkDelete();
              }, context);
            }),
      ));
    }
    return children;
  }

  late final List<ListItemDetail> _formFields;
  final GlobalKey _formKey = GlobalKey();
  final _updatingIndicator = UpdatingIndicator();
  static const _columnSpacing = 16.0;
}
