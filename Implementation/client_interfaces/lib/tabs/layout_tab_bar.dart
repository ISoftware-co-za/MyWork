import 'package:flutter/material.dart';

import 'control_accept_reject.dart';
import 'control_tab_bar.dart';

class LayoutTabBar extends StatelessWidget {
  const LayoutTabBar({required TabController controller, super.key}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(48.0),
        child: Row(
          children: [SizedBox(width: 100, child: ControlTabBar(controller: _controller)), Spacer(), ControlAcceptReject()],
        ));
  }

  final TabController _controller;
}
