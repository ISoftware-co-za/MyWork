import 'package:flutter/material.dart';

import '../execution/executor.dart';
import 'control_icon_button_reject.dart';
import 'control_icon_button_accept.dart';

class LayoutAcceptReject extends StatelessWidget {
  const LayoutAcceptReject({
    required VoidCallback onAccept,
    required VoidCallback onReject,
    super.key,
  }) : _onAccept = onAccept,
       _onReject = onReject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ControlIconButtonReject(
          Icons.close,
          onPressed: () {
            Executor.runCommand('LayoutAcceptReject', 'close', _onReject);
          },
        ),
        ControlIconButtonAccept(
          Icons.check,
          onPressed: () {
            Executor.runCommand('LayoutAcceptReject', 'check', _onAccept);
          },
        ),
      ],
    );
  }

  final VoidCallback _onAccept;
  final VoidCallback _onReject;
}
