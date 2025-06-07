import 'properties.dart';
import 'state_activity_base.dart';

class StateAction extends StateActivityBase {
  late final StateProperty title;
  late final StateProperty description;
  late final StateProperty requester;

  late final StateProperty initialEstimateInMinutes;
  late final StateProperty currentDurationInMinutes;
  late final StateProperty currentEstimateInMinutes;

  late final List<StateWorkEntry> workLog;
  late final StateWorkClose? close;

  StateAction({required super.timestamp,
    String? title,
    String? description,
    String? requester,
    int? initialEstimateInMinutes,
    int? currentDurationInMinutes,
    int? currentEstimateInMinutes,
    List<StateWorkEntry>? workLog,
    this.close}) {
    this.title = StateProperty(value: title);
    this.description = StateProperty(value: description);
    this.requester = StateProperty(value: requester);
    this.initialEstimateInMinutes = StateProperty(value: initialEstimateInMinutes);
    this.currentDurationInMinutes = StateProperty(value: currentDurationInMinutes);
    this.currentEstimateInMinutes = StateProperty(value: currentEstimateInMinutes);

    if (workLog == null) {
      this.workLog = [];
    } else {
      this.workLog = workLog;
    }
  }
}

class StateWorkEntry {
  late final DateTime start;
  late final StateProperty durationInMinutes;
  late final StateProperty currentEstimateInMinutes;
  late final StateProperty notes;

  StateWorkEntry({required this.start, int? durationInMinutes, int? currentEstimateInMinutes, String? notes}) {
    this.durationInMinutes = StateProperty(value: durationInMinutes);
    this.currentEstimateInMinutes = StateProperty(value: currentEstimateInMinutes);
    this.notes = StateProperty(value: notes);
  }
}

class StateWorkClose {
  late final StateProperty notes;

  StateWorkClose({String? notes}) {
    this.notes = StateProperty(value: notes);
  }
}