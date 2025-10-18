import 'package:flutter/material.dart';

import '../../../theme/custom_theme_data_app_header.dart';
import '../../../theme/theme_extension_spacing.dart';
import '../controller/controller_activity_list.dart';
import 'control_activity_list.dart';
import 'layout_activity_list_header.dart';

class LayoutActivityListPanel extends StatelessWidget {
  const LayoutActivityListPanel({required ControllerActivityList controller, required ThemeExtensionSpacing spacingTheme, super.key}) : _controller = controller, _spacingTheme = spacingTheme;

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
            child: Container(
              color: Color.fromARGB(255, 220, 220, 220),
                child: ControlActivityList(controller: _controller, spacingTheme: _spacingTheme))
            )
        ]),
    );
  }

  final ControllerActivityList _controller;
  final ThemeExtensionSpacing _spacingTheme;
}
