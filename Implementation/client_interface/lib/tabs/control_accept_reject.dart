import 'package:client_interfaces1/controller/coordinator_work_and_activity_change.dart';
import 'package:client_interfaces1/controller/state_application.dart';
import 'package:client_interfaces1/tabs/controller_tab_bar.dart';
import 'package:flutter/material.dart';
import '../execution/executor.dart';
import '../controller/provider_state_application.dart';
import '../ui_toolkit/control_icon_button_accept.dart';
import '../ui_toolkit/control_icon_button_reject.dart';

class ControlAcceptReject extends StatelessWidget {
  const ControlAcceptReject({required CoordinatorWorkAndActivityChange coordinatorWorkAndActivityChange, super.key = const Key('ControlAcceptReject')}) : _coordinatorWorkAndActivityChange = coordinatorWorkAndActivityChange;

  @override
  Widget build(BuildContext context) {
    StateApplication state = ProviderStateApplication.of(context)!.state;
    ControllerTabBar controllerTabBar = state.getController<ControllerTabBar>()!;

    return ListenableBuilder(
        listenable: _coordinatorWorkAndActivityChange.isChanged,
        builder: (context, child) {
          return ListenableBuilder(
              listenable: controllerTabBar.isSaving,
              builder: (context, child) {
                if (controllerTabBar.isSaving.value) {
                  return const SizedBox(width: 56, height: 28, child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator())));
                } else if (_coordinatorWorkAndActivityChange.isChanged.value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ControlIconButtonReject(Icons.close, onPressed: () => controllerTabBar.onReject()),
                      ControlIconButtonAccept(Icons.check,
                          onPressed: () async => await Executor.runCommandAsync('ControlAcceptReject', null, () async {
                                await controllerTabBar.onAccept();
                              }))
                    ],
                  );
                }
                return Container();
              });
        });
  }

  final CoordinatorWorkAndActivityChange _coordinatorWorkAndActivityChange;
}
