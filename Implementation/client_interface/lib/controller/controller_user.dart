import '../model/user.dart';
import 'controller_base.dart';

class ControllerUser extends ControllerBase {
  User user = User();
  bool get isLoggedIn => user.userID != null;
}
