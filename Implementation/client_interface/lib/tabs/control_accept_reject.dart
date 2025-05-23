import 'package:flutter/material.dart';
import '../execution/executor.dart';
import '../model/property_changed_registry.dart';
import '../app/controller_work.dart';
import '../app/provider_state_application.dart';
import '../ui_toolkit/custom_icon_buttons.dart';

class ControlAcceptReject extends StatelessWidget {
  const ControlAcceptReject({super.key = const Key('ControlAcceptReject')});

  @override
  Widget build(BuildContext context) {
    ControllerWork controller =
        ProviderStateApplication.of(context)!.workController;
    return ListenableBuilder(
        listenable: PropertyChangedRegistry.hasChanges,
        builder: (context, child) {
          return ListenableBuilder(
              listenable: controller.isSaving,
              builder: (context, child) {
                if (controller.isSaving.value) {
                  return const SizedBox(
                      width: 56,
                      height: 28,
                      child: Center(
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator())));
                } else if (PropertyChangedRegistry.hasChanges.value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButtonReject(Icons.close,
                          onPressed: () => _onRejectPressed(controller)),
                      IconButtonAccept(Icons.check,
                          onPressed: () async =>
                              await _onAcceptPressed(controller, context))
                    ],
                  );
                }
                return Container();
              });
        });
  }

  void _onRejectPressed(ControllerWork controller) {
    controller.onCancel();
  }

  Future<void> _onAcceptPressed(
      ControllerWork controller, BuildContext context) async {
    Executor.runCommandAsync('ControlAcceptReject', null, () async {
      await controller.onSave();
    }, context);
  }
}
