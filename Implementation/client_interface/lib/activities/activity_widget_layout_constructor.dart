import 'package:flutter/material.dart';

import '../model/state_note.dart';
import 'control_activity_control_palette.dart';
import 'control_activity_description.dart';
import 'control_activity_requester.dart';
import 'control_activity_timestamp.dart';
import 'control_activity_title.dart';
import '../model/state_action.dart';

enum Orientation {
  column,
  row,
}

class WidgetGroup {
  Orientation orientation;
  List<Widget> widgets;

  WidgetGroup({required this.orientation, required this.widgets});
}

class WidgetLayout {
  List<WidgetGroup> groups;

  WidgetLayout({required this.groups});
}

class ActivityCommand {
  String id;
  IconData icon;
  String label;

  ActivityCommand({required this.id, required this.icon, required this.label});
}

abstract class ActivityWidgetConstructorBase {
  IconData get icon;
  int get numberOfItems;
  bool? get isClosed;

  List<ActivityCommand> get commands;

  WidgetLayout constructDetailsWidgets(bool isMouseover, Function? onHeightMayChange);
  WidgetLayout? constructItemWidgets(int index, bool isMouseover, Function? onHeightMayChange);
  WidgetLayout? constructCloseWidgets(bool isMouseover, Function? onHeightMayChange);
}

extension ActivityWidgetConstructorBaseExtension on ActivityWidgetConstructorBase {
  bool isSpaceRequiredAfterDetails() => numberOfItems > 0 || isClosed == true;
  bool isSpaceRequiredAfterItems() => isClosed == true;
}

class ActivityWidgetConstructorNote implements ActivityWidgetConstructorBase {
  final StateNote activity;

  ActivityWidgetConstructorNote({required this.activity});

  @override
  IconData get icon => Icons.note;

  @override
  int get numberOfItems => 0;

  @override
  bool? get isClosed => null;

  @override
  List<ActivityCommand> get commands => [];

  @override
  WidgetLayout constructDetailsWidgets(bool isMouseover, Function? onHeightMayChange) {
    return WidgetLayout(groups: [
      WidgetGroup(orientation: Orientation.column, widgets: [
        ControlActivityTimestamp(timestamp: activity.timestamp),
        ControlActivityDescription(
            value: activity.text.value ?? '',
            editable: activity.text.isChanged || isMouseover,
            onValueChanged: (value) {
              onHeightMayChange?.call();
              activity.text.value = value;
            })
      ])
    ]);
  }

  @override
  WidgetLayout? constructItemWidgets(int index, bool isMouseover, Function? onHeightMayChange) {
    return null;
  }

  @override
  WidgetLayout? constructCloseWidgets(bool isMouseover, Function? onHeightMayChange) {
    return null;
  }
}

class ActivityWidgetConstructorWork implements ActivityWidgetConstructorBase {
  final StateAction activity;

  ActivityWidgetConstructorWork({required this.activity});

  @override
  IconData get icon => Icons.work;

  @override
  int get numberOfItems => activity.workLog.length;

  @override
  bool? get isClosed => null;

  @override
  List<ActivityCommand> get commands {
    if (isClosed == true) {
      return _commandsNone;
    }
    return _commandsAll;
  }

  @override
  WidgetLayout constructDetailsWidgets(bool isMouseover, Function? onHeightMayChange) {
    var groups = <WidgetGroup>[];
    groups.add(_constructDetailsWidgetGroup(isMouseover, onHeightMayChange));
    if (activity.close != null) {
      groups.add(_constructOpenWorkEstimateWidgetsGroup(isMouseover));
    } else {
      groups.add(_constructClosedWorkEstimateWidgetsGroup(isMouseover));
    }
    return WidgetLayout(groups: groups);
  }
  @override
  WidgetLayout? constructCloseWidgets(bool isMouseover, Function? onHeightMayChange) {
    return null;
  }

  @override
  WidgetLayout? constructItemWidgets(int index, bool isMouseover, Function? onHeightMayChange) {
    assert(index >= 0 && index < activity.workLog.length, 'The index of the WorkLog item is out of bounds');
    StateWorkEntry logEntry = activity.workLog[index];

    var groups = <WidgetGroup>[];
    groups.add(
        WidgetGroup(orientation: Orientation.column, widgets: [ControlActivityTimestamp(timestamp: logEntry.start)]));
    _constructWorkLogItemEstimateWidgets(logEntry, isMouseover, groups);
    groups.add(WidgetGroup(orientation: Orientation.column, widgets: [
      ControlActivityDescription(
          value: logEntry.notes.value ?? '',
          editable: logEntry.notes.isChanged || isMouseover,
          onValueChanged: (value) {
            onHeightMayChange?.call();
            logEntry.notes.value = value;
          })
    ]));
    return WidgetLayout(groups: groups);
  }

  WidgetGroup _constructDetailsWidgetGroup(bool isMouseover, Function? onHeightMayChange) {
    return WidgetGroup(orientation: Orientation.column, widgets: [
      ControlActivityTimestamp(timestamp: activity.timestamp),
      ControlActivityTitle(
          value: activity.title.value ?? '',
          editable: activity.title.isChanged || isMouseover,
          onValueChanged: (value) {
            activity.title.value = value;
          }),
      ControlActivityRequester(
          value: activity.requester.value ?? '',
          editable: activity.requester.isChanged || isMouseover,
          onValueChanged: (value) {
            activity.requester.value = value;
          }),
      ControlActivityDescription(
          value: activity.description.value ?? '',
          editable: activity.description.isChanged || isMouseover,
          onValueChanged: (value) {
            onHeightMayChange?.call();
            activity.description.value = value;
          }),
    ]);
  }

  WidgetGroup _constructOpenWorkEstimateWidgetsGroup(bool isMouseover) {
    var widgets = <Widget>[];
    widgets.addAll(ControlActivityControlPalette.constructDuration(
        activity.initialEstimateInMinutes.isChanged || isMouseover,
        'Original estimate',
        activity.initialEstimateInMinutes.value, (value) {
      activity.initialEstimateInMinutes.value = value;
    }));
    widgets.addAll(ControlActivityControlPalette.constructDuration(
        activity.currentEstimateInMinutes.isChanged || isMouseover,
        'Current estimate',
        activity.currentEstimateInMinutes.value, (value) {
      activity.currentEstimateInMinutes.value = value;
    }));
    widgets.addAll(ControlActivityControlPalette.constructDuration(
        activity.currentDurationInMinutes.isChanged || isMouseover,
        'Current duration',
        activity.currentDurationInMinutes.value, (value) {
      activity.currentDurationInMinutes.value = value;
    }));
    return WidgetGroup(orientation: Orientation.row, widgets: widgets);
  }

  WidgetGroup _constructClosedWorkEstimateWidgetsGroup(bool isMouseover) {
    var widgets = <Widget>[];
    widgets.addAll(ControlActivityControlPalette.constructDuration(
        activity.initialEstimateInMinutes.isChanged || isMouseover,
        'Original estimate',
        activity.initialEstimateInMinutes.value, (value) {
      activity.initialEstimateInMinutes.value = value;
    }));
    widgets.addAll(ControlActivityControlPalette.constructDuration(
        activity.currentEstimateInMinutes.isChanged || isMouseover,
        'Current estimate',
        activity.currentEstimateInMinutes.value, (value) {
      activity.currentEstimateInMinutes.value = value;
    }));
    widgets.addAll(ControlActivityControlPalette.constructDuration(
        activity.currentDurationInMinutes.isChanged || isMouseover,
        'Current duration',
        activity.currentDurationInMinutes.value, (value) {
      activity.currentDurationInMinutes.value = value;
    }));
    return WidgetGroup(orientation: Orientation.row, widgets: widgets);
  }

  void _constructWorkLogItemEstimateWidgets(StateWorkEntry logEntry, bool isMouseover, List<WidgetGroup> groups) {
    var estimateWidgets = <Widget>[];
    estimateWidgets.addAll(ControlActivityControlPalette.constructDuration(
        logEntry.currentEstimateInMinutes.isChanged || isMouseover,
        'Current estimate',
        logEntry.currentEstimateInMinutes.value, (value) {
      logEntry.currentEstimateInMinutes.value = value;
    }));
    estimateWidgets.addAll(ControlActivityControlPalette.constructDuration(
        logEntry.durationInMinutes.isChanged || isMouseover, 'Duration', logEntry.durationInMinutes.value, (value) {
      activity.currentEstimateInMinutes.value = value;
    }));
    groups.add(WidgetGroup(orientation: Orientation.row, widgets: estimateWidgets));
  }

  final _commandsAll = <ActivityCommand>[
    ActivityCommand(id: 'logWork', icon: Icons.add, label: 'Log work'),
    ActivityCommand(id: 'close', icon: Icons.close, label: 'Close'),
  ];
  final _commandsNone = <ActivityCommand>[];
}
