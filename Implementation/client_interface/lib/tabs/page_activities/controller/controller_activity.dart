import 'package:client_interfaces1/tabs/page_activities/controller/data_source_autocomplete_person.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'list_item_person.dart';
import '../../../controller/controller_base.dart';
import '../../../model/activity.dart';
import '../../../model/person_list.dart';
import '../../../model/person.dart';

class ControllerActivity extends ControllerBase {
  final PersonList people = PersonList();

  late final DataSourceAutocompletePerson peopleDataSource;
  final ValueListenable<Activity?> selectedActivity;

  ControllerActivity(this.selectedActivity) {
    peopleDataSource = DataSourceAutocompletePerson(people: people, onPersonSelected: onRecipientSelectedFromDataSource, onPersonEntered: onRecipientEntered);
  }

  static List<DropdownMenuEntry<ActivityState>> getActivityStateDropdownItems() {
    return ActivityState.values.map((state) {
      return DropdownMenuEntry<ActivityState>(value: state, label: state.toString().split('.').last);
    }).toList();
  }

  void onRecipientSelectedFromDataSource(ListItemPerson selectedPerson) {
    onRecipientSelected(selectedPerson.person);
  }

  void onRecipientSelected(Person selectedPerson) {
    assert(selectedActivity.value != null, 'An activity is required when setting the recipient.');
    selectedActivity.value!.recipient.value = selectedPerson;
    debugPrint('Recipient selected "${selectedPerson.toString()}"');
  }

  void onRecipientEntered(String text) {
    debugPrint('Recipient entered "$text"');
  }
}
