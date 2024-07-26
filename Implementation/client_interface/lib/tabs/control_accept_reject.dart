import 'package:flutter/material.dart';

class ControlAcceptReject extends StatelessWidget {
  const ControlAcceptReject({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: _onRejectPressed, icon: const Icon(Icons.close)),
        IconButton(onPressed: _onAcceptPressed, icon: const Icon(Icons.check))
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
