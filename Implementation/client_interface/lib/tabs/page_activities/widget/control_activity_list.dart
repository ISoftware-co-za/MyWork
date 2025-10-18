import 'package:client_interfaces1/tabs/page_activities/controller/controller_activity_list.dart';
import 'package:flutter/widgets.dart';

import '../../../theme/theme_extension_spacing.dart';
import 'control_activity_list_item.dart';

class ControlActivityList extends StatelessWidget {
  const ControlActivityList({required ControllerActivityList controller, required ThemeExtensionSpacing spacingTheme, super.key}) : _controller = controller, _spacingTheme = spacingTheme;

  @override
  Widget build(BuildContext context) {
    if (_controller.activityList.value == null) {
      return const Center(child: Text('No work is selected. Select work to list and manage its activities.'));
    }
    return ListenableBuilder(
        listenable: _controller.activityList.value!,
        builder: (context, child) {

          return ListView.builder(
            itemCount: _controller.activityList.value!.items.length,
            itemBuilder: (context, index) {
              return ControlActivityListItem(
                activity: _controller.activityList.value!.items[index],
                activityListController: _controller,
                spacingTheme: _spacingTheme
              );
            },
          );
        });
  }

  final ControllerActivityList _controller;
  final ThemeExtensionSpacing _spacingTheme;
}
