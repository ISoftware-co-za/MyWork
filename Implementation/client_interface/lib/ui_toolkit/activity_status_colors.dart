import 'package:client_interfaces1/model/activity.dart';
import 'package:flutter/material.dart';

class ActivityStatusColors {
  static const Color idle = Color(0xFF808080);
  static const Color busy = Color(0xFF5050FF);
  static const Color done = Color(0xFF00A000);
  static const Color paused = Color(0xFF96B400);
  static const Color canceled = Color(0xFFFF0000);

  static IconData getIconForState(ActivityState state) {
    switch (state) {
      case ActivityState.idle:
        return Icons.stop;
      case ActivityState.busy:
        return Icons.play_arrow;
      case ActivityState.done:
        return Icons.check;
      case ActivityState.paused:
        return Icons.pause;
      case ActivityState.cancelled:
        return Icons.close;
    }
  }

  static Color getColorForState(ActivityState state) {
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
    return statusColor;

    /*
    return Color.alphaBlend(
      Colors.white.withValues(alpha: 0.45),
      statusColor,
    );
    */
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

  static Color getHoverColorForState(ActivityState state) {
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
      Colors.white.withValues(alpha: 0.66),
      statusColor,
    );
  }
}
