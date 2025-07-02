
import 'package:flutter/material.dart';

import '../../../execution/executor.dart';
import '../../../controller/controller_work.dart';
import '../../../model/work.dart';
import '../../../model/work_type_list.dart';
import '../../../ui_toolkit/form/form.dart';
import '../../../ui_toolkit/hover.dart';
import '../controller/data_source_autocomplete_work_type.dart';
import '../controller/list_item_detail_autocomplete.dart';
import '../controller/list_item_detail_base.dart';
import '../controller/list_item_detail_parchment.dart';
import '../controller/list_item_detail_text.dart';

class LayoutDetailsForm extends StatefulWidget {
  LayoutDetailsForm(
      {required String userID, required WorkTypeList workTypes, required ControllerWork controller, super.key})
      : _userID = userID,
        _workTypes = workTypes,
        _controller = controller {
    _fields = _createFormFields(controller);
  }

  @override
  State<LayoutDetailsForm> createState() => _LayoutDetailsFormState();

  List<ListItemDetailBase> _createFormFields(ControllerWork controller) {
    Work work = controller.selectedWork.value!;
    return [
      ListItemDetailText(label: 'Name', property: work.name),
      ListItemDetailAutocomplete(
          label: 'Type',
          property: work.type,
          dataSource: DataSourceAutocompleteWorkType(_userID, _workTypes, work.type)),
      ListItemDetailText(label: 'Reference', property: work.reference),
      ListItemDetailParchment(label: 'Description', property: work.description)
    ];
  }

  final String _userID;
  final WorkTypeList _workTypes;
  final ControllerWork _controller;
  late final List<ListItemDetailBase> _fields;
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
    var children = <Widget>[];
    try {
      for (var field in widget._fields) {
        if (field is ListItemDetailText) {
          _addFormField(field, children);
        } else if (field is ListItemDetailParchment) {
          _addFleatherFormField(field, children);
        } else if (field is ListItemDetailAutocomplete) {
          _addAutocompleteFormField(field, children);
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

  void _addFormField(ListItemDetailText field, List<Widget> children) {
    var widget = ControlFormField(label: field.label, property: field.property, editable: _isMouseover);
    children.add(widget);
  }

  void _addFleatherFormField(ListItemDetailParchment field, List<Widget> children) {
    var widget = ControlFleatherFormField(
      label: field.label,
      property: field.property,
      editable: _isMouseover,
    );
    children.add(widget);
  }

  void _addAutocompleteFormField(ListItemDetailAutocomplete field, List<Widget> children) {
    var widget = ControlAutocompleteFormField(
        label: field.label, property: field.property, editable: _isMouseover, dataSource: field.dataSource);
    children.add(widget);
  }

  final GlobalKey _formKey = GlobalKey();
  static const _columnSpacing = 16.0;
  bool _isMouseover = false;
}
