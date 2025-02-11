import 'package:flutter/widgets.dart' hide Notification;

import 'notifications.dart';

class ControllerNotifications extends ChangeNotifier {
  //#region PROPERTIES

  List<Notification> get notifications => _notifications;
  final List<Notification> _notifications = [];

  //#endregion

  //#region METHODS

  void add(Notification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void remove(Notification notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  //#endregion
}