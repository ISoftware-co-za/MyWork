import 'package:flutter/material.dart';

import '../theme/custom_theme_data_app_header.dart';
import '../theme/theme_extension_app_header.dart';
import 'control_accept_reject.dart';
import 'control_tab_bar.dart';

class LayoutTabBar extends StatelessWidget {
  const LayoutTabBar({required TabController controller, super.key}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = CustomThemeDataAppHeader.getTheme();
    ThemeExtensionAppHeader appHeaderThemeExtension = theme.extension<ThemeExtensionAppHeader>()!;

    return Theme(
      data: theme,
      child: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: appHeaderThemeExtension.backgroundColor,
            child: Row(
              children: [SizedBox(width: 100, child: ControlTabBar(controller: _controller)), Spacer(), ControlAcceptReject()],
            ),
          )),
    );
  }

  final TabController _controller;
}
