import 'package:client_interfaces1/controller/coordinator_work_and_activity_change.dart';
import 'package:flutter/material.dart';

import '../theme/custom_theme_data_app_header.dart';
import '../theme/theme_extension_app_header.dart';
import 'control_accept_reject.dart';
import 'control_tab_bar.dart';

class LayoutTabBar extends StatelessWidget {
  const LayoutTabBar({
    required CoordinatorWorkAndActivityChange coordinatorWorkAndActivityChange,
    required TabController controller,
    super.key,
  }) : _coordinatorWorkAndActivityChange = coordinatorWorkAndActivityChange,
       _controller = controller;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = CustomThemeDataAppHeader.getTheme();
    ThemeExtensionAppHeader appHeaderThemeExtension = theme
        .extension<ThemeExtensionAppHeader>()!;

    return Theme(
      data: theme,
      child: Container(
        color: appHeaderThemeExtension.backgroundColor,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ControlTabBar(controller: _controller),
            ),
            Spacer(),
            ControlAcceptReject(coordinatorWorkAndActivityChange: _coordinatorWorkAndActivityChange),
          ],
        ),
      ),
    );
  }

  final TabController _controller;
  final CoordinatorWorkAndActivityChange _coordinatorWorkAndActivityChange;
}
