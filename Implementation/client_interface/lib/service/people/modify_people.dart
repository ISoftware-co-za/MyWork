import '../service_client_base.dart';
import '../update_entity.dart';
import 'person_details.dart';

class ModifyPeopleRequest {
  List<PersonDetails>? addedPeople;
  List<UpdateChild>? updatedPeople;
  List<String>? removedPeopleIds;
  ModifyPeopleRequest(
    this.addedPeople,
    this.updatedPeople,
    this.removedPeopleIds,
  );

  Map<String, dynamic> toJson() {
    return {
      'addedPeople': addedPeople?.map((person) => person.toJson()).toList(),
      'updatedPeople': updatedPeople?.map((update) => update.toJson()).toList(),
      'removedPersonIds': removedPeopleIds,
    };
  }
}

class ModifyPeopleResponse extends ServiceClientResponse {
  String? addedPeopleMessage;
  List<ModifyOutcome>? addedPeople;
  String? updatePeopleErrorMessage;
  List<ModifyOutcome>? updatedPeople;
  String? removePeopleErrorMessage;
  List<ModifyOutcome>? removedPeople;

  ModifyPeopleResponse(
    this.addedPeopleMessage,
    this.addedPeople,
    this.updatePeopleErrorMessage,
    this.updatedPeople,
    this.removePeopleErrorMessage,
    this.removedPeople,
  );

  factory ModifyPeopleResponse.fromJson(Map<String, dynamic> json) {
    List<ModifyOutcome>? addedPeople = null;
    List<ModifyOutcome>? updatedPeople = null;
    List<ModifyOutcome>? removedPeople = null;

    if (json['addedPeople'] != null) {
      addedPeople = _toListOfOutcomes(json['addedPeople']);
    }
    if (json['updatedPeople'] != null) {
      updatedPeople = _toListOfOutcomes(json['updatedPeople']);
    }
    if (json['removedPeople'] != null) {
      removedPeople = _toListOfOutcomes(json['removedPeople']);
    }
    return ModifyPeopleResponse(
      json['addedPeopleMessage'],
      addedPeople,
      json['updatePeopleErrorMessage'],
      updatedPeople,
      json['removePeopleErrorMessage'],
      removedPeople,
    );
  }

  static List<ModifyOutcome> _toListOfOutcomes(List<dynamic> jsonArray) {
    final outcomes = <ModifyOutcome>[];
    for(int index = 0; index < jsonArray.length; ++index) {
      final entry = jsonArray[index];
      outcomes.add(ModifyOutcome(entry['id'] as String, entry['errorMessage'] as String?));
    }
    return outcomes;
  }
}

class ModifyOutcome {
  String id;
  String? errorMessage;
  ModifyOutcome(this.id, this.errorMessage);

  factory ModifyOutcome.fromJson(Map<String, dynamic> json) {
    return ModifyOutcome(json['id'] as String, json['errorMessage'] as String?);
  }
}
