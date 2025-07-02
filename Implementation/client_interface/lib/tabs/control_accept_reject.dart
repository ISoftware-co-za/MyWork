import 'package:client_interfaces1/tabs/controller_tab_bar.dart';
import 'package:flutter/material.dart';
import '../execution/executor.dart';
import '../model/property_changed_registry.dart';
import '../controller/provider_state_application.dart';
import '../ui_toolkit/control_custom_icon_buttons.dart';

class ControlAcceptReject extends StatelessWidget {
  const ControlAcceptReject({super.key = const Key('ControlAcceptReject')});

  @override
  Widget build(BuildContext context) {
    ProviderStateApplication state = ProviderStateApplication.of(context)!;
    ControllerTabBar controllerTabBar = state.getController<ControllerTabBar>()!;

    return ListenableBuilder(
        listenable: PropertyChangedRegistry.hasChanges,
        builder: (context, child) {
          return ListenableBuilder(
              listenable: controllerTabBar.isSaving,
              builder: (context, child) {
                if (controllerTabBar.isSaving.value) {
                  return const SizedBox(width: 56, height: 28, child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator())));
                } else if (PropertyChangedRegistry.hasChanges.value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButtonReject(Icons.close, onPressed: () => controllerTabBar.onReject()),
                      IconButtonAccept(Icons.check,
                          onPressed: () async => await Executor.runCommandAsync('ControlAcceptReject', null, () async {
                                await controllerTabBar.onAccept();
                              }, context))
                    ],
                  );
                }
                return Container();
              });
        });
  }
}
