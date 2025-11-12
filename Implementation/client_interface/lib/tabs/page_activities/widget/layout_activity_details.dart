import 'package:flutter/material.dart';

import '../../../dialog_people/controller/controller_dialog_people.dart';
import '../../../dialog_people/widget/layout_dialog_people.dart';
import '../../../execution/executor.dart';
import '../../../model/activity.dart';
import '../../../model/person_list.dart';
import '../../../model/provider_state_model.dart';
import '../../../theme/theme_extension_control_activity_state_and_what.dart';
import '../../../theme/theme_extension_spacing.dart';
import '../../../ui_toolkit/control_delete.dart';
import '../../../ui_toolkit/form/form.dart';
import '../../../ui_toolkit/hover.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'control_activity_state_and_what.dart';

class LayoutActivityDetails extends StatefulWidget {
  const LayoutActivityDetails({
    required ControllerActivityList controllerActivityList,
    required ControllerActivity controllerActivity,
    required ThemeExtensionSpacing spacingTheme,
    required ThemeExtensionControlActivityStateAndWhat
    controlActivityStateAndWhatTheme,
    super.key,
  }) : _controllerActivityList = controllerActivityList,
        _controllerActivity = controllerActivity,
        _spacingTheme = spacingTheme,
        _controlActivityStateAndWhatTheme = controlActivityStateAndWhatTheme;

  @override
  State<LayoutActivityDetails> createState() => _LayoutFormActivityState();

  final ControllerActivityList _controllerActivityList;
  final ControllerActivity _controllerActivity;
  final ThemeExtensionSpacing _spacingTheme;
  final ThemeExtensionControlActivityStateAndWhat
  _controlActivityStateAndWhatTheme;
}

class _LayoutFormActivityState extends State<LayoutActivityDetails> {
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
        final Activity activity =
        widget._controllerActivity.selectedActivity.value!;
        final AutocompleteTrailingAction trailingAction =
        AutocompleteTrailingAction(
          Icons.person,
              (Offset offset, Size size) =>
              Executor.runCommand('person', 'LayoutActivityForm', () {
                _showPeopleDialog(context, offset, size);
              }),
        );
        return Padding(
          padding: widget._spacingTheme.edgeInsetsWide,
          child: Container(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ControlActivityStateAndWhat(
                  activity: activity,
                  isMouseover: _isMouseover,
                  spacingTheme: widget._spacingTheme,
                  controlActivityStateAndWhatTheme:
                  widget._controlActivityStateAndWhatTheme,
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
                        dataSource: widget._controllerActivity.peopleDataSource,
                        width: 300,
                        trailingAction: trailingAction,
                      ),
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
                  label: 'How',
                  property: activity.how,
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

  void _showPeopleDialog(BuildContext context, Offset offset, Size size) {
    ProviderStateModel providerStateModel = ProviderStateModel.of(context)!;
    var controller = ControllerDialogPeople(
      providerStateModel.state.getInstance<PersonList>()!,
      widget._controllerActivityList.activityList.value!,
          (person) {
        widget._controllerActivity.onRecipientSelected(person);
      },
      context,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutDialogPeople(
          topLeft: Offset(offset.dx + size.width, offset.dy),
          controller: controller,
        );
      },
    );
  }

  final GlobalKey _formKey = GlobalKey();
  bool _isMouseover = false;
}
