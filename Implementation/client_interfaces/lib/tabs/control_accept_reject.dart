import 'package:flutter/material.dart';

import '../ui%20toolkit/property_changed_registry.dart';
import '../ui toolkit/custom_icon_buttons.dart';

class ControlAcceptReject extends StatelessWidget {
  const ControlAcceptReject({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PropertyChangedRegistry.hasChanges,
      builder: (context, child) {
        if (PropertyChangedRegistry.hasChanges.value) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButtonReject(Icons.close, onPressed: _onRejectPressed),
              IconButtonAccept(Icons.check, onPressed: _onAcceptPressed)
            ],
          );
        }
        return Container();
      }
    );
  }

  void _onRejectPressed() {
    PropertyChangedRegistry.rejectChanges();
  }

  void _onAcceptPressed() {
    if (PropertyChangedRegistry.validateChanges()) {
      // Use service API to store changes
      PropertyChangedRegistry.acceptChanges();
    }
  }
}
