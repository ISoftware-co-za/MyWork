import 'package:client_interfaces1/model/activity.dart';
import 'package:flutter/material.dart';

class ActivityStatusColors {
  static const Color idle = Color(0xFF808080);
  static const Color busy = Color(0xFF0000FF);
  static const Color done = Color(0xFF00FF00);
  static const Color paused = Color(0xFFF5B64D);
  static const Color canceled = Color(0xFF00FFFF);

  static Color getColorForState(ActivityState state) {
    switch (state) {
      case ActivityState.idle:
        return idle;
      case ActivityState.busy:
        return busy;
      case ActivityState.done:
        return done;
      case ActivityState.paused:
        return paused;
      case ActivityState.cancelled:
        return canceled;
    }
  }

  static Color getLightColorForState(ActivityState state) {
    Color statusColor;
    switch (state) {
      case ActivityState.idle:
        statusColor = idle;
      case ActivityState.busy:
        statusColor = busy;
      case ActivityState.done:
        statusColor = done;
      case ActivityState.paused:
        statusColor = paused;
      case ActivityState.cancelled:
        statusColor = canceled;
    }
    return Color.alphaBlend(
      Colors.white.withValues(alpha: 0.8),
      statusColor,
    );
  }
}
