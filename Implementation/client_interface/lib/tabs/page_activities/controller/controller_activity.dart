import 'package:client_interfaces1/model/activity_note.dart';
import 'package:client_interfaces1/tabs/page_activities/controller/data_source_autocomplete_person.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../model/model_property_change_context.dart';
import 'list_item_person.dart';
import '../../../controller/controller_base.dart';
import '../../../model/activity.dart';
import '../../../model/person_list.dart';
import '../../../model/person.dart';

class ControllerActivity extends ControllerBase {
  //#region PROPERTIES

  final PersonList people;
  late final DataSourceAutocompletePerson peopleDataSource;
  final ValueListenable<Activity?> selectedActivity;

  //#endregion

  //#region CONSTRUCTOR

  ControllerActivity(
    this.people,
    ModelPropertyChangeContext context,
    this.selectedActivity,
  ) : _context = context {
    peopleDataSource = DataSourceAutocompletePerson(
      people: people,
      onPersonSelected: onRecipientSelectedFromDataSource,
      onPersonEntered: onRecipientEntered,
    );
  }

  //#endregion

  //#region METHODS

  static List<DropdownMenuEntry<ActivityState>>
  getActivityStateDropdownItems() {
    return ActivityState.values.map((state) {
      return DropdownMenuEntry<ActivityState>(
        value: state,
        label: state.toString().split('.').last,
      );
    }).toList();
  }

  //#endregion

  //#region EVENT HANDLERS

  void onRecipientSelectedFromDataSource(ListItemPerson selectedPerson) {
    onRecipientSelected(selectedPerson.person);
  }

  void onRecipientSelected(Person selectedPerson) {
    assert(
      selectedActivity.value != null,
      'An activity is required when setting the recipient.',
    );
    selectedActivity.value!.recipient.value = selectedPerson;
  }

  void onRecipientEntered(String fullName) async {
    assert(
      selectedActivity.value != null,
      'An activity is required when setting the recipient.',
    );
    final newPerson = Person.createWithFullName(
      people.context,
      fullName,
    );
    selectedActivity.value!.recipient.value = newPerson;
    if (selectedActivity.value!.recipient.validate()) {
      people.add(newPerson);
      await people.acceptChanges();
    }
  }

  void onNoteAdded() {
    final note = ActivityNote.create(_context);
    selectedActivity.value!.notes.add(note);
  }

  Future onDeleteNote(ActivityNote note) async {
    Activity activity = selectedActivity.value!;
    activity.notes.remove(note);
    if (activity.validate()) {
      await activity.update();
    }
  }

  //#endregion

  //#region FIELDS

  final ModelPropertyChangeContext _context;

  //#endregion
}
