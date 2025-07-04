import 'package:client_interfaces1/ui_toolkit/activity_status_colors.dart';
import 'package:flutter/material.dart';

import '../../../model/activity.dart';

class ControlActivityListItem extends StatefulWidget {
  ControlActivityListItem({required Activity activity, required ValueNotifier<Activity?> selectedActivity, super.key}) :
        _activity = activity, _selectedActivity = selectedActivity;

  @override
  State<ControlActivityListItem> createState() => _ControlActivityListItemState();

  final Activity _activity;
  final ValueNotifier<Activity?> _selectedActivity;
}

class _ControlActivityListItemState extends State<ControlActivityListItem> {

  @override
  void initState() {
    super.initState();
    _isSelected = _calculateSelectionState();
    widget._selectedActivity.addListener(() {
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
    });
  }

  bool _calculateSelectionState() {
    return widget._selectedActivity.value == widget._activity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget._selectedActivity.value = widget._activity;
      },
      child: ListenableBuilder(
          listenable: widget._activity.state,
          builder: (context, child) {
            debugPrint('${widget._activity.what.value} = $_isSelected');
            return CustomPaint(
              // color: _isSelected ? Colors.white : ActivityStatusColors.getLightColorForState(widget._activity.state.value),
              painter: _ActivityListItemPainter(_isSelected, widget._activity.state.value),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.play_arrow, color: ActivityStatusColors.getColorForState(widget._activity.state.value)),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: ListenableBuilder(
                        listenable: widget._activity.what,
                        builder: (context, child) {
                          return Text(
                            widget._activity.what.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          );
                        }),
                  ),
                ]),
              ),
            );
          }),
    );
  }

  bool _isSelected = false;
}

class _ActivityListItemPainter extends CustomPainter {
  _ActivityListItemPainter(this.isSelected, this.state);

  final bool isSelected;
  final ActivityState state;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ActivityStatusColors.getLightColorForState(state)
      ..style = PaintingStyle.fill;
    if (isSelected) {
      final path = Path();
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - size.height/2, size.height/2);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
