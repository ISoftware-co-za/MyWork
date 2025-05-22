import 'package:client_interfaces1/model/work_type_list.dart';
import 'package:client_interfaces1/state/controller_work_types.dart';
import 'package:client_interfaces1/tabs/page_details/layout_details_form.dart';
import 'package:flutter/material.dart';

import '../../state/controller_user.dart';
import '../../state/controller_work.dart';
import '../../state/provider_state_application.dart';
import '../../model/work.dart';

//----------------------------------------------------------------------------------------------------------------------

class PageDetails extends StatelessWidget {
  PageDetails({super.key}) {}

  @override
  Widget build(BuildContext context) {
    ControllerWork controllerWork =
        ProviderStateApplication.of(context)!.workController;
    ControllerUser controllerUser =
        ProviderStateApplication.of(context)!.userController;
    ControllerWorkTypes controllerWorkTypes =
        ProviderStateApplication.of(context)!.workTypesController;

    assert(controllerUser.user?.userID != null, "Cannot display work details without a logged in user");

    return ValueListenableBuilder(
        valueListenable: controllerWork.selectedWork,
        builder: (BuildContext context, Work? work, Widget? child) {
          if (controllerWork.hasWork) {
            return _generateWorkForm(controllerUser.user!.userID!, controllerWorkTypes.workTypes!, controllerWork);
          } else {
            return _displayNoWork();
          }
        });
  }

  Widget _generateWorkForm(String userID, WorkTypeList workTypes, ControllerWork controller, ) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 700),
        child: LayoutDetailsForm(userID: userID, workTypes: workTypes, controller: controller),
      ),
    );
  }

  Widget _displayNoWork() {
    return const Center(child: Text('No work selected'));
  }
}
