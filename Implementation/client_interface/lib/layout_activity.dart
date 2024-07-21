import 'package:client_interface/activity_widget_layout_constructor.dart' as widget_constructor;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'activity_widget_layout_constructor.dart';
import 'control_activity_command_panel.dart';

class LayoutConstants {
  static const double iconSize = 40;
  static const double rowSpacing = 16;
  static const double columnSpacing = 6;
  static const double groupSpacing = 24;
  static const double activitySpacing = 36;
}

class LayoutActivity extends StatefulWidget {
  final widget_constructor.ActivityWidgetConstructorBase model;
  const LayoutActivity({required this.model, super.key});

  @override
  State<LayoutActivity> createState() => _LayoutActivityState();
}

class _LayoutActivityState extends State<LayoutActivity> {
  @override
  Widget build(BuildContext context) {
    var columnWidgets = <Widget>[];
    columnWidgets.add(_DetailsRegion(model: widget.model));
    for (int itemIndex = 0; itemIndex < widget.model.numberOfItems; ++itemIndex) {
      columnWidgets.add(_ItemRegion(model: widget.model, itemIndex: itemIndex));
    }
    if (_isMouseover) {
      if (widget.model.commands.isNotEmpty) {
        columnWidgets.add(ControlActivityCommandPanel(
            commands: widget.model.commands, onCommandSelected: _onActivityCommandSelected));
        columnWidgets.add(const SizedBox(height: LayoutConstants.columnSpacing));
      }
    } else {
      columnWidgets.add(const SizedBox(height: LayoutConstants.activitySpacing + LayoutConstants.columnSpacing));
    }

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isMouseover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isMouseover = false;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnWidgets,
      ),
    );
  }

  bool _isMouseover = false;

  void _onActivityCommandSelected(String id) {
    debugPrint('Activity command selected: $id');
  }
}

class _DetailsRegion extends StatefulWidget {
  final widget_constructor.ActivityWidgetConstructorBase model;
  const _DetailsRegion({required this.model});

  @override
  State<_DetailsRegion> createState() => _DetailsRegionState();
}

class _DetailsRegionState extends State<_DetailsRegion> {

  @override
  void initState() {
    super.initState();
    _onHeightMayChange();
  }

  @override
  Widget build(BuildContext context) {
    var detailsRows = <Widget>[];
    WidgetLayout layout = widget.model.constructDetailsWidgets(_isMouseover, _onHeightMayChange);
    _addDetails(widget.model.icon, layout, detailsRows);
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isMouseover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isMouseover = false;
        });
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: detailsRows),
    );
  }

  void _addDetails(IconData icon, widget_constructor.WidgetLayout widgetLayout, List<Widget> rows) {
    List<Widget> columnChildren = _LayoutHelpers.constructLayout(widgetLayout);
    if (widget.model.isSpaceRequiredAfterDetails()) {
      columnChildren.add(const SizedBox(height: LayoutConstants.groupSpacing));
    }
    rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Marker(lineVisible: widget.model.numberOfItems > 0, contentHeight: _activityDetailHeight, iconData: icon),
      const SizedBox(width: LayoutConstants.rowSpacing),
      Expanded(child: Column(
          key: _activityDetailsKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        )
      )
    ]));
  }

  void _onHeightMayChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _activityDetailsKey.currentContext!.findRenderObject() as RenderBox;
      _activityDetailHeight.value = renderBox.size.height;
    });
  }

  bool _isMouseover = false;
  final GlobalKey _activityDetailsKey = GlobalKey();
  final ValueNotifier<double?> _activityDetailHeight = ValueNotifier<double?>(null);
}

class _ItemRegion extends StatefulWidget {
  final widget_constructor.ActivityWidgetConstructorBase model;
  final int itemIndex;
  const _ItemRegion({required this.model, required this.itemIndex});

  @override
  State<_ItemRegion> createState() => _ItemRegionState();
}

class _ItemRegionState extends State<_ItemRegion> {
  @override
  void initState() {
    super.initState();
    _onHeightMayChange();
  }

  @override
  Widget build(BuildContext context) {
    var detailsRows = <Widget>[];
    _addItem(widget.model.constructItemWidgets(widget.itemIndex, _isMouseover, _onHeightMayChange)!, detailsRows);
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isMouseover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isMouseover = false;
        });
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: detailsRows),
    );
  }

  void _addItem(widget_constructor.WidgetLayout widgetLayout, List<Widget> rows) {
    List<Widget> columnChildren = _LayoutHelpers.constructLayout(widgetLayout);
    if ((widget.itemIndex < widget.model.numberOfItems - 1) || widget.model.isSpaceRequiredAfterItems()) {
      columnChildren.add(const SizedBox(height: LayoutConstants.groupSpacing));
    }
    rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Marker(lineVisible: true, contentHeight: _activityDetailHeight),
      const SizedBox(width: LayoutConstants.rowSpacing),
      Expanded(
        child: Column(
          key: _activityDetailsKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: columnChildren,
        ),
      )
    ]));
  }

  void _onHeightMayChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _activityDetailsKey.currentContext!.findRenderObject() as RenderBox;
      _activityDetailHeight.value = renderBox.size.height;
    });
  }

  bool _isMouseover = false;
  final GlobalKey _activityDetailsKey = GlobalKey();
  final ValueNotifier<double?> _activityDetailHeight = ValueNotifier<double?>(null);
}

class _LayoutHelpers {
  static List<Widget> constructLayout(widget_constructor.WidgetLayout layout) {
    var columnChildren = <Widget>[];
    for (widget_constructor.WidgetGroup group in layout.groups) {
      if (group.orientation == widget_constructor.Orientation.column) {
        _addColumnToLayout(group.widgets, columnChildren);
      } else {
        _addRowToLayout(group.widgets, columnChildren);
      }
    }
    return columnChildren;
  }

  static void _addColumnToLayout(List<Widget> groupWidgets, List<Widget> columnChildren) {
    for (Widget widget in groupWidgets) {
      columnChildren.add(widget);
      columnChildren.add(const SizedBox(height: LayoutConstants.columnSpacing));
    }
  }

  static void _addRowToLayout(List<Widget> groupWidgets, List<Widget> columnChildren) {
    var rowChildren = <Widget>[];
    for (int index = 0; index < groupWidgets.length; ++index) {
      Widget widget = groupWidgets[index];
      rowChildren.add(widget);
      if (index != groupWidgets.length - 1) {
        rowChildren.add(const SizedBox(width: LayoutConstants.rowSpacing));
      }
    }
    columnChildren.add(Row(children: rowChildren));
    columnChildren.add(const SizedBox(height: LayoutConstants.columnSpacing));
  }
}

class _Marker extends StatefulWidget {
  final IconData? iconData;
  final bool lineVisible;
  final ValueNotifier<double?> contentHeight;
  const _Marker({this.iconData, required this.lineVisible, required this.contentHeight});

  @override
  State<_Marker> createState() => _MarkerState();
}

class _MarkerState extends State<_Marker> {
  @override
  void initState() {
    super.initState();
    widget.contentHeight.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.contentHeight.value != null && widget.contentHeight.value! > 0) {
      var children = <Widget>[];
      if (widget.lineVisible) {
        children.add(Positioned(
            top: (widget.iconData != null) ? LayoutConstants.iconSize / 2 : 0,
            left: LayoutConstants.iconSize / 2 - 1,
            child: Container(
              width: 2,
              height: widget.contentHeight.value,
              color: _markerColor,
            )));
      }
      if (widget.iconData != null) {
        children.add(Icon(widget.iconData, size: LayoutConstants.iconSize));
      } else if (widget.lineVisible) {
        double size = LayoutConstants.iconSize / 2.5;
        double left = (LayoutConstants.iconSize - size) / 2;
        children.add(Positioned(
            left: left,
            child: Container(
                width: size,
                height: size,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: _markerColor // Specify the circle color here
                        ))));
      }
      return ValueListenableBuilder(
          valueListenable: widget.contentHeight,
          builder: (context, value, child) {
            return SizedBox(
                width: LayoutConstants.iconSize, height: widget.contentHeight.value, child: Stack(children: children));
          });
    } else {
      return const SizedBox(width: LayoutConstants.iconSize);
    }
  }

  static const Color _markerColor = Color.fromARGB(255, 200, 200, 200);
}
