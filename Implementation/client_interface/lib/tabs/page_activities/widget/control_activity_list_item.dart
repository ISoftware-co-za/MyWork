import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/theme/theme_extension_spacing.dart';
import 'package:client_interfaces1/ui_toolkit/activity_status_colors.dart';
import 'package:flutter/material.dart';

import '../../../model/activity.dart';
import '../controller/controller_activity_list.dart';

class ControlActivityListItem extends StatefulWidget {
  ControlActivityListItem({
    required Activity activity,
    required ControllerActivityList activityListController,
    required ThemeExtensionSpacing spacingTheme,
    super.key,
  }) : _activity = activity,
       _activityListController = activityListController,
       _spacingTheme = spacingTheme;

  @override
  State<ControlActivityListItem> createState() =>
      _ControlActivityListItemState();

  final Activity _activity;
  final ControllerActivityList _activityListController;
  final ThemeExtensionSpacing _spacingTheme;
}

class _ControlActivityListItemState extends State<ControlActivityListItem> {
  @override
  void initState() {
    super.initState();
    _isSelected = _calculateSelectionState();
    widget._activityListController.selectedActivity.addListener(
      onActivitySelected,
    );
  }

  @override
  void dispose() {
    widget._activityListController.selectedActivity.removeListener(
      onActivitySelected,
    );
    super.dispose();
  }

  bool _calculateSelectionState() {
    return widget._activityListController.selectedActivity.value ==
        widget._activity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Executor.runCommand(
          "ControlActivityList",
          "LayoutPageActivities",
          () =>
              widget._activityListController.onSelectActivity(widget._activity),
        );
      },
      child: ListenableBuilder(
        listenable: widget._activity.state,
        builder: (context, child) {
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
            child: CustomPaint(
              painter: _ActivityListItemPainter(
                _isSelected,
                _isMouseover,
                widget._activity.state.value,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  widget._spacingTheme.paddingNarrow,
                  widget._spacingTheme.paddingNarrow,
                  widget._spacingTheme.paddingWide,
                  widget._spacingTheme.paddingNarrow,
                ),
                child: Row(
                  children: [
                    Icon(
                      ActivityStatusColors.getIconForState(
                        widget._activity.state.value,
                      ),
                      color: ActivityStatusColors.getColorForState(
                        widget._activity.state.value,
                      ),
                      size: 30,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: widget._activity.what,
                        builder: (context, child) {
                          return Text(
                            widget._activity.what.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.0),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onActivitySelected() {
    if (_calculateSelectionState()) {
      setState(() {
        _isSelected = true;
      });
    } else {
      if (_isSelected) {
        setState(() {
          _isSelected = false;
        });
      }
    }
  }

  bool _isSelected = false;
  bool _isMouseover = false;
}

class _ActivityListItemPainter extends CustomPainter {
  _ActivityListItemPainter(this.isSelected, this.isMouseover, this.state);

  final bool isSelected;
  final bool isMouseover;
  final ActivityState state;

  @override
  void paint(Canvas canvas, Size size) {
    if (isMouseover) {
      final paint = Paint()
        ..color = Color.fromARGB(255, 240, 240, 240)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
    if (isSelected) {
      final paint = Paint()
        ..color = Color.fromARGB(255, 254, 247, 255)
        ..style = PaintingStyle.fill;
      final path = Path();
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - size.height / 3, size.height / 2);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
