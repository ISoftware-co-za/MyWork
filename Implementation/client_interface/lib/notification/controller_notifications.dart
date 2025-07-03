import '../controller/controller_base.dart';
import 'notifications.dart';

class ControllerNotifications extends ControllerBase {
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