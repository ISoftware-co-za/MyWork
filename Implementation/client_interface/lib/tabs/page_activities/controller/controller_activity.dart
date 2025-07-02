import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../controller/controller_base.dart';
import '../../../model/activity.dart';

class ControllerActivity extends ControllerBase {
  final ValueListenable<Activity?> selectedActivity;

  ControllerActivity(this.selectedActivity) {
    selectedActivity.addListener(() {
      debugPrint('Selected work changed: ${selectedActivity.value?.what.value}');
    });
  }

  static List<DropdownMenuEntry<ActivityState>> getActivityStateDropdownItems() {
    return ActivityState.values.map((state) {
      return DropdownMenuEntry<ActivityState>(value: state, label: state.toString().split('.').last);
    }).toList();
  }
}
