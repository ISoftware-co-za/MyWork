import 'package:client_interfaces1/theme_extension_control_work_button.dart';
import 'package:flutter/material.dart';

import '../custom_theme_data_app_header.dart';
import '../theme_extension_app_header.dart';
import 'layout_work_selector.dart';
import 'control_search.dart';
import 'control_notifications.dart';
import 'control_user.dart';

class LayoutHeader extends StatelessWidget {
  const LayoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = CustomThemeDataAppHeader.getTheme();
    ThemeExtensionAppHeader appHeaderThemeExtension = theme.extension<ThemeExtensionAppHeader>()!;
    ThemeExtensionControlWorkButton workButtonTheme = theme.extension<ThemeExtensionControlWorkButton>()!;
    return Theme(
      data: theme,
      child: Container(
        color: appHeaderThemeExtension.backgroundColor,
        height: appHeaderThemeExtension.height,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: LayoutWorkSelector(label: 'Select work', workButtonTheme: workButtonTheme)),
            Expanded(flex: 1, child: ControlSearch()),
            Spacer(flex: 1,),
            ControlNotifications(),
            SizedBox(width: workButtonTheme.padding), // Add some space between buttons
            ControlUser()
          ],
        ),
      ),
    );
  }
}
