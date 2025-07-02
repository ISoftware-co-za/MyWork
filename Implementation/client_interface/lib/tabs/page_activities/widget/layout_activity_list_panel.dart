import 'package:flutter/material.dart';

import '../../../theme/custom_theme_data_app_header.dart';
import '../controller/controller_activity_list.dart';
import 'control_activity_list.dart';
import 'layout_activity_list_header.dart';

class LayoutActivityListPanel extends StatelessWidget {
  const LayoutActivityListPanel({required ControllerActivityList controller, super.key}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = CustomThemeDataAppHeader.getTheme();
    return Theme(
      data: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutActivityListHeader(controller: _controller),
          Expanded(
            child: ControlActivityList(controller: _controller)
            )
        ]),
    );
  }

  final ControllerActivityList _controller;
}
