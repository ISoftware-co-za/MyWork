import 'package:client_interfaces1/execution/executor.dart';
import 'package:flutter/material.dart';

import '../../../controller/controller_work.dart';
import '../../../controller/coordinator_work_and_activity_list_loader.dart';
import '../../../model/work.dart';
import '../../../model/work_type_list.dart';
import '../../../ui_toolkit/form/form.dart';
import '../../../ui_toolkit/hover.dart';
import '../../../ui_toolkit/control_delete.dart';
import '../controller/data_source_autocomplete_work_type.dart';
import '../controller/list_item_detail_autocomplete.dart';
import '../controller/list_item_detail_base.dart';
import '../controller/list_item_detail_parchment.dart';
import '../controller/list_item_detail_text.dart';

class LayoutDetailsForm extends StatefulWidget {
  LayoutDetailsForm({
    required String userID,
    required WorkTypeList workTypes,
    required ControllerWork controller,
    required CoordinatorWorkActivityListLoader coordinator,
    super.key,
  }) : _userID = userID,
       _workTypes = workTypes,
       _controller = controller,
        _coordinator = coordinator {
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
        dataSource: DataSourceAutocompleteWorkType(
          _userID,
          _workTypes,
          work.type,
        ),
      ),
      ListItemDetailText(label: 'Reference', property: work.reference),
      ListItemDetailParchment(label: 'Description', property: work.description),
    ];
  }

  final String _userID;
  final WorkTypeList _workTypes;
  final ControllerWork _controller;
  final CoordinatorWorkActivityListLoader _coordinator;
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
      },
    );
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        },
      ),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    var children = <Widget>[];
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
      children.add(
        Center(
          child: ControlDelete(pageName: 'LayoutDetailsForm', onDelete: () async {
            Executor.runCommandAsync('ControlDelete', "DetailsForm", () async {
              await widget._coordinator.onDeleteWork();
            });
          }),
        )
      );
    }

    return children;
  }

  void _addFormField(ListItemDetailText field, List<Widget> children) {
    var widget = ControlFormField(
      label: field.label,
      property: field.property,
      editable: _isMouseover,
    );
    children.add(widget);
  }

  void _addFleatherFormField(
    ListItemDetailParchment field,
    List<Widget> children,
  ) {
    var widget = ControlFleatherFormField(
      label: field.label,
      property: field.property,
      editable: _isMouseover,
    );
    children.add(widget);
  }

  void _addAutocompleteFormField(
    ListItemDetailAutocomplete field,
    List<Widget> children,
  ) {
    var widget = ControlAutocompleteFormField(
      label: field.label,
      property: field.property,
      editable: _isMouseover,
      dataSource: field.dataSource,
    );
    children.add(widget);
  }

  final GlobalKey _formKey = GlobalKey();
  static const _columnSpacing = 16.0;
  bool _isMouseover = false;
}
