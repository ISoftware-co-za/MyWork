import 'state_base.dart';

class StateWork extends StateActivityBase {
  late final StateProperty<String?> title;
  late final StateProperty<String?> description;
  late final StateProperty<String?> requester;

  late final StateProperty<int?> initialEstimateInMinutes;
  late final StateProperty<int?> currentDurationInMinutes;
  late final StateProperty<int?> currentEstimateInMinutes;

  late final List<StateWorkEntry> workLog;
  late final StateWorkClose? close;

  StateWork({required super.timestamp,
    String? title,
    String? description,
    String? requester,
    int? initialEstimateInMinutes,
    int? currentDurationInMinutes,
    int? currentEstimateInMinutes,
    List<StateWorkEntry>? workLog,
    this.close}) {
    this.title = StateProperty<String?>(activityBase: this, value: title);
    this.description = StateProperty<String?>(activityBase: this, value: description);
    this.requester = StateProperty<String?>(activityBase: this, value: requester);
    this.initialEstimateInMinutes = StateProperty<int?>(activityBase: this, value: initialEstimateInMinutes);
    this.currentDurationInMinutes = StateProperty<int?>(activityBase: this, value: currentDurationInMinutes);
    this.currentEstimateInMinutes = StateProperty<int?>(activityBase: this, value: currentEstimateInMinutes);

    if (workLog == null) {
      this.workLog = [];
    } else {
      this.workLog = workLog;
    }
  }
}

class StateWorkEntry extends StateBase {
  late final DateTime start;
  late final StateProperty<int?> durationInMinutes;
  late final StateProperty<int?> currentEstimateInMinutes;
  late final StateProperty<String?> notes;

  StateWorkEntry({required this.start, int? durationInMinutes, int? currentEstimateInMinutes, String? notes}) {
    this.durationInMinutes = StateProperty<int?>(activityBase: this, value: durationInMinutes);
    this.currentEstimateInMinutes = StateProperty<int?>(activityBase: this, value: currentEstimateInMinutes);
    this.notes = StateProperty<String?>(activityBase: this, value: notes);
  }
}

class StateWorkClose extends StateBase {
  late final StateProperty<String?> notes;

  StateWorkClose({String? notes}) {
    this.notes = StateProperty<String?>(activityBase: this, value: notes);
  }
}