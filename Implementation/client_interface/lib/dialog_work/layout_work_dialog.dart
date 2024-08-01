import 'package:flutter/material.dart';

import 'control_header.dart';

class LayoutWorkDialog extends StatelessWidget {
  const LayoutWorkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    WorkDialogTheme theme = Theme.of(context).extension<WorkDialogTheme>()!;
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(0, Theme.of(context).appBarTheme.toolbarHeight!, 0, 0),
        child: Container(
            width: theme.width,
            height: theme.height,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(theme.gridSize),
              child: const Column(children: [
                ControlHeader(),
              ]),
            )));
  }
}
