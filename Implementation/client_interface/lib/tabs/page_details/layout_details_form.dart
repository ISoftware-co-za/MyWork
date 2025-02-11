import 'package:client_interfaces1/state/provider_state_application.dart';
import 'package:client_interfaces1/tabs/page_details/list_item_detail.dart';
import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../state/controller_work.dart';
import '../../state/state_work.dart';
import '../../ui toolkit/control_form_fields.dart';
import '../../ui toolkit/hover.dart';

class LayoutDetailsForm extends StatefulWidget {
  const LayoutDetailsForm({required ControllerWork controller, super.key}) : _controller = controller;

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
      ListItemDetail(label: 'Name', property: work.name, editorType: ListItemDetailEditor.text),
      ListItemDetail(label: 'Type', property: work.type, editorType: ListItemDetailEditor.autocomplete),
      ListItemDetail(label: 'Reference', property: work.reference, editorType: ListItemDetailEditor.text),
      ListItemDetail(label: 'Description', property: work.description, editorType: ListItemDetailEditor.parchment)
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controllerHover = ProviderHover.of(context).controller;
    controllerHover.registerHoverableWidget(
        name: ControllerHover.workDetails,
        widgetKey: _formKey,
        isVisible: true,
        onHover: (isHovered) {
          setState(() {
            _isMouseover = isHovered;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _buildForm(context);
    return Container(
      key: _formKey,
      color: Colors.transparent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    final provider = ProviderStateApplication.of(context)!;
    var children = <Widget>[];
    for (var field in _formFields) {
      if (field.editorType == ListItemDetailEditor.text) {
        children.add(
            ControlFormField(label: field.label, property: field.property, editable: _isMouseover));
      } else if (field.editorType == ListItemDetailEditor.parchment) {
        children.add(ControlFleatherFormField(
            label: field.label, property: field.property, editable: _isMouseover));
      } else if (field.editorType == ListItemDetailEditor.autocomplete) {
        provider.workTypesController.setStateProperty(field.property);
        children.add(ControlAutocompleteFormField(
            label: field.label,
            property: field.property,
            editable: _isMouseover,
            dataSource: provider.workTypesController));
      }
      children.add(const SizedBox(height: _columnSpacing));
    }

    if (widget._controller.hasExistingWork && _isMouseover) {
      children.add(Center(
        child: TextButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Executor.runCommandAsync("Delete", null, () async {
                await widget._controller.onWorkDelete();
              }, context);
            }),
      ));
    }
    return children;
  }

  late final List<ListItemDetail> _formFields;
  final GlobalKey _formKey = GlobalKey();
  static const _columnSpacing = 16.0;
  bool _isMouseover = false;
}
