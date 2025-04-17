import 'package:flutter/material.dart';

import 'layout_work_selector.dart';
import 'control_search.dart';
import 'control_notifications.dart';
import 'control_user.dart';

class LayoutHeader extends StatelessWidget {
  const LayoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.appBarTheme.backgroundColor,
      height: theme.appBarTheme.toolbarHeight,
      padding: const EdgeInsets.all(8),
      child: const Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: ControlWorkSelector(label: 'Select work', )),
          Expanded(flex: 1, child: ControlSearch()),
          Spacer(flex: 1,),
          ControlNotifications(),
          ControlUser()
        ],
      ),
    );
  }
}
