import 'package:flutter/material.dart';

import '../controller/controller_activity_list.dart';
import 'control_add_activity.dart';

class LayoutActivityListHeader extends StatelessWidget {
  const LayoutActivityListHeader({required ControllerActivityList controller, super.key}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 100, 100, 100),
      child: Padding(padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ControlAddActivity(controller: _controller)
        ]
      ),),
    );
  }

  final ControllerActivityList _controller;
}
