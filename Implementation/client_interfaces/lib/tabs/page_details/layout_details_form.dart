import 'package:client_interfaces1/tabs/page_details/list_item_detail.dart';
import 'package:flutter/material.dart';

import '../../state/state_work.dart';
import '../../ui toolkit/control_form_fields.dart';

class LayoutDetailsForm extends StatefulWidget {
  const LayoutDetailsForm({required StateWork work, super.key}) : _work = work;

  @override
  State<LayoutDetailsForm> createState() => _LayoutDetailsFormState();

  final StateWork _work;
}

class _LayoutDetailsFormState extends State<LayoutDetailsForm> {
  @override
  void initState() {
    super.initState();
    _formFields = [
      ListItemDetail(label: 'Name', property: widget._work.name, editorType: ListItemDetailEditor.text),
      ListItemDetail(label: 'Type', property: widget._work.type, editorType: ListItemDetailEditor.autocomplete),
      ListItemDetail(label: 'Reference', property: widget._work.reference, editorType: ListItemDetailEditor.text),
      ListItemDetail(
          label: 'Description', property: widget._work.description, editorType: ListItemDetailEditor.parchment)
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _buildForm();
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.opaque,
      onEnter: (event) {
        setState(() {
          _updatingIndicator.isMouseover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _updatingIndicator.isMouseover = false;
        });
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }

  List<Widget> _buildForm() {
    var children = <Widget>[];
    for (var field in _formFields) {
      if (field.editorType == ListItemDetailEditor.text) {
        children.add(ControlFormField(label: field.label, property: field.property, editable: _updatingIndicator.isUpdating));
      } else if (field.editorType == ListItemDetailEditor.parchment) {
        children.add(ControlFleatherFormField(label: field.label, property: field.property, updatingIndicator: _updatingIndicator));
      } else if (field.editorType == ListItemDetailEditor.autocomplete) {
        children.add(ControlAutocompleteFormField(
            label: field.label,
            property: field.property,
            suggestions: const ['One', 'Two', 'Three'],
            updatingIndicator: _updatingIndicator));
      }
      children.add(const SizedBox(height: _columnSpacing));
    }
    return children;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    setState(() {
      debugPrint('_handlePointerMove = ${event.position})');
    });
  }

  late final List<ListItemDetail> _formFields;
  final UpdatingIndicator _updatingIndicator = UpdatingIndicator();
  static const _columnSpacing = 16.0;
}
