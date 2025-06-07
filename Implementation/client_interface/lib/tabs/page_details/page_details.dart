import 'package:client_interfaces1/tabs/page_details/layout_details_form.dart';
import 'package:flutter/material.dart';

import '../../app/controller_user.dart';
import '../../app/controller_work.dart';
import '../../app/controller_work_types.dart';
import '../../app/provider_state_application.dart';
import '../../model/work.dart';
import '../../model/work_type_list.dart';

//----------------------------------------------------------------------------------------------------------------------

class PageDetails extends StatelessWidget {
  PageDetails({super.key}) {}

  @override
  Widget build(BuildContext context) {
    ControllerWork controllerWork =
        ProviderStateApplication.of(context)!.getController<ControllerWork>()!;
    ControllerUser controllerUser =
        ProviderStateApplication.of(context)!.getController<ControllerUser>()!;
    ControllerWorkTypes controllerWorkTypes =
        ProviderStateApplication.of(context)!.getController<ControllerWorkTypes>()!;

    assert(controllerUser.user.userID != null, "Cannot display work details without a logged in user");

    return ValueListenableBuilder(
        valueListenable: controllerWork.selectedWork,
        builder: (BuildContext context, Work? work, Widget? child) {
          if (controllerWork.hasWork) {
            return _generateWorkForm(controllerUser.user.userID!, controllerWorkTypes.workTypes!, controllerWork);
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
