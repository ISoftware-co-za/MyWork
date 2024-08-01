import 'package:flutter/material.dart';

import '../controls/custom_icon_buttons.dart';

class ControlAcceptReject extends StatelessWidget {
  const ControlAcceptReject({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButtonReject(Icons.close, onPressed: _onRejectPressed),
        IconButtonAccept(Icons.check, onPressed: _onAcceptPressed)
      ],
    );
  }

  void _onRejectPressed() {
    debugPrint('_onRejectPressed');
  }

  void _onAcceptPressed() {
    debugPrint('_onAcceptPressed');
  }
}
