import 'package:client_interface/state/state_base.dart';

class StateWork extends StateBase {
  late final StateProperty<String?> name;
  late final StateProperty<String?> reference;
  late final StateProperty<String?> description;
  late final StateProperty<String?> type;

  StateWork({
    String? name,
    String? reference,
    String? description,
    String? type}) {
    this.name = StateProperty<String?>(activityBase: this, value: name);
    this.reference = StateProperty<String?>(activityBase: this, value: reference);
    this.description = StateProperty<String?>(activityBase: this, value: description);
    this.type = StateProperty<String?>(activityBase: this, value: type);
  }
}