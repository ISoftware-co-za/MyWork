import 'package:flutter/material.dart';
import '../state/property_changed_registry.dart';
import '../state/provider_state_application.dart';
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
              IconButtonReject(Icons.close, onPressed: () => _onRejectPressed(context)),
              IconButtonAccept(Icons.check, onPressed: () => _onAcceptPressed(context))
            ],
          );
        }
        return Container();
      }
    );
  }

  void _onRejectPressed(BuildContext context) {
    ProviderStateApplication.of(context)!.workController.onCancel();
  }

  void _onAcceptPressed(BuildContext context) {
    ProviderStateApplication.of(context)!.workController.onSave();
  }
}
