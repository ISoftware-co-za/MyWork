import 'package:flutter/material.dart';

import 'control_header.dart';

class LayoutWorkDialog extends StatelessWidget {
  const LayoutWorkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(0, Theme.of(context).appBarTheme.toolbarHeight!, 0, 0),
        child: Container(
            width: 800,
            height: 500,
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(children: [
                ControlHeader(),
              ]),
            )));
  }
}
