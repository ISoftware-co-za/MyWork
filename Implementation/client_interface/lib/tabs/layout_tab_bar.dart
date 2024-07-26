import 'package:client_interface/tabs/control_accept_reject.dart';
import 'package:client_interface/tabs/control_tab_bar.dart';
import 'package:flutter/material.dart';

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
