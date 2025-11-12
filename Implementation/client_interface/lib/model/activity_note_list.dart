import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'activity_note.dart';

class ActivityNoteList extends ChangeNotifier {
  late final List<ActivityNote> items;

  //#region CONSTRUCTION

  ActivityNoteList(List<ActivityNote> notes)
    : _notes = notes {
    this.items = UnmodifiableListView(_notes);
  }

  //#endregion

  //#region METHODS

  bool validate() {
    bool areNotesValid = true;
    for(ActivityNote note in _notes) {
      areNotesValid &= note.validate();
    }
    return areNotesValid;
  }

  void add(ActivityNote note) {
    _notes.add(note);
    _newNotes.add(note);
    notifyListeners();
  }

  void setNoteIds(List<String> ids) {
    for(int index = 0; index < _notes.length; ++index) {
      _newNotes[index].id = ids[index];
    }
    _newNotes.clear();
  }

  void remove(ActivityNote note) {
    if (note.isNew) {
      _notes.remove(note);
      _newNotes.remove(note);
    } else {
      _oldNotes.add(note);
      _notes.remove(note);
    }
    notifyListeners();
  }

  void acceptChanged()
  {
    _oldNotes.clear();
  }

  void discardChange()
  {
    _notes.addAll(_oldNotes);
    _notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    _oldNotes.clear();
  }

  List<String> listDeletedNoteId() {
    return _oldNotes.map((note) => note.id).toList();
  }

  //#endregion

  //#region FIELDS

  final List<ActivityNote> _notes;
  final List<ActivityNote> _newNotes = [];
  final List<ActivityNote> _oldNotes = [];

  //#endregion
}
