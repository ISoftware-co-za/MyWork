import 'package:client_interfaces1/controller/controller_work.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../controller/provider_state_application.dart';
import '../theme/custom_theme_data_app_header.dart';
import '../model/work.dart';
import '../theme/theme_extension_app_header.dart';
import '../theme/theme_extension_control_work_button.dart';
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
    ValueListenable<Work?> selectedWork = ProviderStateApplication.of(context)!.getController<ControllerWork>()!.selectedWork;

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
            Expanded(flex: 1, child: LayoutWorkSelector(selectedWork: selectedWork, workButtonTheme: workButtonTheme)),
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
