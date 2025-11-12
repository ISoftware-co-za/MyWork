import 'package:client_interfaces1/ui_toolkit/control_icon_button_normal.dart';
import 'package:flutter/material.dart';

import '../../../model/activity_note.dart';
import '../../../ui_toolkit/form/form.dart';

typedef ActivityNoteCallback = void Function(ActivityNote note);

class ControlNote extends StatefulWidget {
  const ControlNote({
    required ActivityNote note,
    required ThemeExtensionForm formTheme,
    required ActivityNoteCallback onDeleteNote,
    super.key,
  }) : _formTheme = formTheme,
       _note = note,
        _onDeleteNote = onDeleteNote;

  @override
  State<ControlNote> createState() => _ControlNoteState();

  final ActivityNote _note;
  final ThemeExtensionForm _formTheme;
  final ActivityNoteCallback _onDeleteNote;
}

class _ControlNoteState extends State<ControlNote> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {_setTimelineHeight(true);});
    widget._note.text.addListener(_setTimelineHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: ControlNoteTimeline(heighNotifier: _contentColumnHeight),
        ),
        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _isMouseover = true),
            onExit: (_) => setState(() => _isMouseover = false),
            child: Column(
              key: _contentColumnKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  child: Row(
                    children: [
                      Text(
                        widget._note.timestamp.toString(),
                        style: widget._formTheme.labelStyle,
                      ),
                      SizedBox(width: 8),
                      if (_isMouseover)
                        ControlIconButtonNormal(icon: Icon(Icons.delete), onPressed: () => widget._onDeleteNote(widget._note)),
                    ],
                  ),
                ),
                ControlFormField(
                  label: '',
                  property: widget._note.text,
                  editable: _isMouseover,
                  maximumLines: 3,
                  noLabel: true,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _setTimelineHeight([bool forceHeightUpdate = false]) {
    if (widget._note.text.isValueNotifying || forceHeightUpdate) {
      final RenderBox? renderBox =
      _contentColumnKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        _contentColumnHeight.value = renderBox.size.height;
      }
    }
  }

  bool _isMouseover = false;
  final GlobalKey _contentColumnKey = GlobalKey();
  final ValueNotifier<double?> _contentColumnHeight = ValueNotifier(null);
}

class ControlNoteTimeline extends StatelessWidget {
  const ControlNoteTimeline({
    required ValueNotifier<double?> heighNotifier,
    super.key,
  }) : _heighNotifier = heighNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _heighNotifier,
      builder: (BuildContext context, double? currentValue, Widget? child) {
        if (currentValue == null) {
          return SizedBox.shrink();
        }
        return SizedBox(
          height: currentValue,
          child: CustomPaint(painter: _NoteTimelineCustomPainter()),
        );
      },
    );
  }

  final ValueNotifier<double?> _heighNotifier;
}

class _NoteTimelineCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.width / 2;
    final Paint paint = Paint()
      ..color = Color.fromARGB(255, 220, 220, 220)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;
    final centreOfCircle = Offset(size.width / 2, 4 + radius);
    canvas.drawCircle(centreOfCircle, radius, paint);
    canvas.drawLine(
      Offset(centre, 4 + radius),
      Offset(centre, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_NoteTimelineCustomPainter oldDelegate) => false;

  static const double radius = 6;
}
