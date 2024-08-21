import 'package:flutter/material.dart';

import 'control_accept_reject.dart';
import 'control_tab_bar.dart';

class LayoutTabBar extends StatelessWidget {
  const LayoutTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const PreferredSize(
        preferredSize: Size.fromHeight(48.0),
        child: Row(
          children: [SizedBox(width: 100, child: ControlTabBar()), Spacer(), ControlAcceptReject()],
        ));
  }
}
