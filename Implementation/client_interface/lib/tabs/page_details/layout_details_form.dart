import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../state/controller_work.dart';
import '../../state/provider_state_application.dart';
import '../../state/state_work.dart';
import '../../ui_toolkit/form/form.dart';
import '../../ui_toolkit/hover.dart';
import 'list_item_detail.dart';

class LayoutDetailsForm extends StatefulWidget {
  LayoutDetailsForm({required ControllerWork controller, super.key}) : _controller = controller {
    _fields = _createFormFields(controller);
  }

  @override
  State<LayoutDetailsForm> createState() => _LayoutDetailsFormState();

  List<ListItemDetail> _createFormFields(ControllerWork controller) {
    StateWork work = controller.selectedWork.value!;
    return [
      ListItemDetail(label: 'Name', property: work.name, editorType: ListItemDetailEditor.text),
      ListItemDetail(label: 'Type', property: work.type, editorType: ListItemDetailEditor.autocomplete),
      ListItemDetail(label: 'Reference', property: work.reference, editorType: ListItemDetailEditor.text),
      ListItemDetail(label: 'Description', property: work.description, editorType: ListItemDetailEditor.parchment)
    ];
  }

  final ControllerWork _controller;
  late final List<ListItemDetail> _fields;
}

class _LayoutDetailsFormState extends State<LayoutDetailsForm> {
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
    return Container(
      key: _formKey,
      color: Colors.transparent,
      child: ValueListenableBuilder(
          valueListenable: widget._controller.selectedWork,
          builder: (context, work, child) {
            List<Widget> children = _buildForm(context);
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
          }),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    final provider = ProviderStateApplication.of(context)!;
    var children = <Widget>[];
    try {
      for (var field in widget._fields) {
        if (field.editorType == ListItemDetailEditor.text) {
          _addFormField(field, children);
        } else if (field.editorType == ListItemDetailEditor.parchment) {
          _addFleatherFormField(field, children);
        } else if (field.editorType == ListItemDetailEditor.autocomplete) {
          provider.workTypesController.setStateProperty(field.property);
            _addAutocompleteFormField(field, provider, children);
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
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    return children;
  }

  void _addFormField(ListItemDetail field, List<Widget> children) {
    var widget = ControlFormField(label: field.label, property: field.property, editable: _isMouseover);
    children.add(widget);
  }

  void _addFleatherFormField(ListItemDetail field, List<Widget> children) {
    var widget = ControlFleatherFormField(
      label: field.label,
      property: field.property,
      editable: _isMouseover,
    );
    children.add(widget);
  }

  void _addAutocompleteFormField(ListItemDetail field, ProviderStateApplication provider, List<Widget> children) {
    var widget = ControlAutocompleteFormField(
        label: field.label,
        property: field.property,
        editable: _isMouseover,
        dataSource: provider.workTypesController);
    children.add(widget);
  }

  final GlobalKey _formKey = GlobalKey();
  static const _columnSpacing = 16.0;
  bool _isMouseover = false;
}
