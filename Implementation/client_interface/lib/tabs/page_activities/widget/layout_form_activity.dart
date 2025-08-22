import 'package:client_interfaces1/dialog_people/controller/controller_dialog_people.dart';
import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/ui_toolkit/form/form.dart';
import 'package:flutter/material.dart';

import '../../../dialog_people/widget/layout_dialog_people.dart';
import '../../../model/activity.dart';
import '../../../ui_toolkit/control_delete.dart';
import '../../../ui_toolkit/hover.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'control_activity_state_and_what.dart';

class LayoutFormActivity extends StatefulWidget {
  const LayoutFormActivity({
    required ControllerActivityList controllerActivityList,
    required ControllerActivity controllerActivity,
    super.key,
  }) : _controllerActivityList = controllerActivityList,
       _controllerActivity = controllerActivity;

  @override
  State<LayoutFormActivity> createState() => _LayoutFormActivityState();

  final ControllerActivityList _controllerActivityList;
  final ControllerActivity _controllerActivity;
}

class _LayoutFormActivityState extends State<LayoutFormActivity> {

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
    return ListenableBuilder(
      listenable: widget._controllerActivity.selectedActivity,
      builder: (context, _) {
        if (widget._controllerActivity.selectedActivity.value == null) {
          return const Center(child: Text('No activity selected'));
        }

        final Activity activity =
            widget._controllerActivity.selectedActivity.value!;
        final AutocompleteTrailingAction trailingAction = AutocompleteTrailingAction(
          Icons.person, () => Executor.runCommand(
          'person',
          'LayoutActivityForm',
              () {
            _showPeopleDialog(context);
          },
        ));
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ControlActivityStateAndWhat(
                  activity: activity,
                  isMouseover: _isMouseover,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ControlDateFormField(
                        label: 'Due date',
                        property: activity.dueDate,
                        editable: _isMouseover,
                      ),
                    ),
                    Expanded(
                      child: ControlAutocompleteFormField(
                        label: 'Recipient',
                        property: activity.recipient,
                        editable: _isMouseover,
                        dataSource:
                            widget._controllerActivity.peopleDataSource,
                        width: 300,
                        trailingAction: trailingAction),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ControlFormField(
                  label: 'Why',
                  property: activity.why,
                  editable: _isMouseover,
                  maximumLines: 3,
                ),
                const SizedBox(height: 16),
                ControlFormField(
                  label: 'Notes',
                  property: activity.notes,
                  editable: _isMouseover,
                  maximumLines: 3,
                ),
                const SizedBox(height: 16),
                if (_isMouseover && !activity.isNew)
                  Center(
                    child: ControlDelete(
                      pageName: 'LayoutActivityForm',
                      onDelete: () async {
                        await widget._controllerActivityList.onDeleteActivity();
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPeopleDialog(BuildContext context) {
    var controller = ControllerDialogPeople((person) {
      widget._controllerActivity.onRecipientSelected(person);
    }, context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutDialogPeople(controller: controller);
      },
    );
  }

  final GlobalKey _formKey = GlobalKey();
  bool _isMouseover = false;
}
