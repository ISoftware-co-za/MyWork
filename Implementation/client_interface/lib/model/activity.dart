import 'package:client_interfaces1/model/activity_note.dart';
import 'package:client_interfaces1/model/data_conversion.dart';
import 'package:client_interfaces1/model/person.dart';
import 'package:get_it/get_it.dart';

import '../service/activities/create_activity.dart';
import '../service/activities/service_client_activities.dart';
import '../service/service_client_base.dart';
import '../service/update_entity.dart';
import 'activity_note_list.dart';
import 'model_property.dart';
import 'model_property_change_context.dart';
import 'validator_base.dart';
import 'validator_first_last_name.dart';

enum ActivityState {
  idle,
  busy,
  done,
  paused,
  cancelled;

  static ActivityState fromString(String state) {
    switch (state.toLowerCase()) {
      case 'idle':
        return ActivityState.idle;
      case 'busy':
        return ActivityState.busy;
      case 'done':
        return ActivityState.done;
      case 'paused':
        return ActivityState.paused;
      case 'cancelled':
        return ActivityState.cancelled;
      default:
        throw ArgumentError('Unknown activity state: $state');
    }
  }
}

class Activity extends PropertyOwner {
  //#region PROPERTIES

  late String id;
  late String workId;
  late final ModelProperty<String> what;
  late final ModelProperty<ActivityState> state;
  late final ModelProperty<DateTime?> dueDate;
  late final ModelProperty<Person?> recipient;
  late final ModelProperty<String> why;
  late final ModelProperty<String> how;
  late final ActivityNoteList notes;

  bool get isNew => id.isEmpty;

  //#endregion

  //#region CONSTRUCTION

  Activity(
    ModelPropertyChangeContext context,
    this.id,
    this.workId,
    String what,
    ActivityState state,
    DateTime? dueDate,
    Person? recipient,
    String? why,
    String? how,
    this.notes,
  ) : super(context) {
    _context = context;
    _initialiseInstance(what, state, dueDate, recipient, why, how);
  }

  Activity.createNew(ModelPropertyChangeContext context, String workId)
    : super(context) {
    _context = context;
    id = '';
    this.workId = workId;
    notes = ActivityNoteList([]);
    _initialiseInstance('', ActivityState.idle);
  }

  //#endrgion

  //#region METHODS

  bool validate() {
    return what.validate() &&
        state.validate() &&
        dueDate.validate() &&
        recipient.validate() &&
        why.validate() &&
        how.validate() &&
        notes.validate();
  }

  Future create() async {
    List<CreateActivityNote>? notesInRequest =
        _addNotesToCreateActivityRequest();
    CreateActivityRequest request = _createCreateActivityRequest(
      notesInRequest,
    );

    var response = await _serviceClient.create(workId, request);
    if (response is CreateActivityResponse) {
      id = response.id;
      if (response.noteIds != null) {
        notes.setNoteIds(response.noteIds!);
        notes.acceptChanged();
      }
    } else if (response is ValidationProblemResponse) {
      invalidate(response.errors);
    }
  }

  Future update() async {
    List<EntityProperty>? updatedProperties = listUpdatedProperties();
    List<ChangeChildEntity>? childUpdates = <ChangeChildEntity>[];
    _addNoteChanges(childUpdates);

    if (updatedProperties.isNotEmpty || childUpdates.isNotEmpty) {
      var request = ChangeEntityRequest(
        updatedProperties: (updatedProperties.length > 0)
            ? updatedProperties
            : null,
        childUpdates: (childUpdates.length > 0) ? childUpdates : null,
      );
      var response = await _serviceClient.update(workId, id, request);
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      } else if (response is ChangeEntityResponse) {
        ChildEntityTypeInResponse? noteChanges = response
            .getUpdateForEntityType('CreateActivityNote');
        if (noteChanges != null && noteChanges.createResults != null) {
          List<String>? noteId = noteChanges.listCreateIds();
          if (noteId != null && noteId.isNotEmpty)
            notes.setNoteIds(noteId);
        }
      }
      notes.acceptChanged();
    }
  }

  Future delete() async {
    await _serviceClient.delete(workId, id);
  }

  @override
  String mapPropertyToUpdateRequestProperty(String name) {
    return (name == 'recipient') ? 'recipientId' : name;
  }

  //#endregion

  //#region PRIVATE METHODS

  void _initialiseInstance(
    String what,
    ActivityState state, [
    DateTime? dueDate,
    Person? recipient,
    String? why,
    String? how,
  ]) {
    if (why == null) {
      why = '';
    }
    if (how == null) {
      how = '';
    }
    this.what = ModelProperty(
      context: _context,
      value: what,
      validators: [
        ValidatorRequired(invalidMessageTemplate: 'What is required'),
        ValidatorMaximumCharacters(
          maximumCharacters: 80,
          invalidMessageTemplate: 'What should be 80 characters or less',
        ),
      ],
    );
    this.state = ModelProperty(context: _context, value: state);
    this.dueDate = ModelProperty(context: _context, value: dueDate);
    this.recipient = ModelProperty(
      context: context,
      value: recipient,
      validators: [ValidatorFirstLastName()],
    );
    this.why = ModelProperty(
      context: _context,
      value: why,
      validators: [
        ValidatorMaximumCharacters(
          maximumCharacters: 240,
          invalidMessageTemplate: 'Why should be 240 characters or less',
        ),
      ],
    );
    this.how = ModelProperty(
      context: _context,
      value: how,
      validators: [
        ValidatorMaximumCharacters(
          maximumCharacters: 240,
          invalidMessageTemplate: 'Notes should be 240 characters or less',
        ),
      ],
    );

    properties = {
      'what': this.what,
      'state': this.state,
      'dueDate': this.dueDate,
      'recipient': this.recipient,
      'why': this.why,
      'how': this.how,
    };
  }

  List<CreateActivityNote>? _addNotesToCreateActivityRequest() {
    List<CreateActivityNote>? notesInRequest;
    if (notes.items.isNotEmpty) {
      notesInRequest = notes.items
          .map(
            (note) => CreateActivityNote(
              DataConversionModelToService.toISO8601DateTime(note.timestamp),
              note.text.value,
            ),
          )
          .toList();
    }
    return notesInRequest;
  }

  CreateActivityRequest _createCreateActivityRequest(
    List<CreateActivityNote>? notesInRequest,
  ) {
    var request = CreateActivityRequest(
      what: what.value,
      state: state.value.name,
      dueDate: dueDate.value == null
          ? null
          : DataConversionModelToService.toISO8601Date(dueDate.value),
      recipientId: recipient.value == null ? null : recipient.value!.id,
      why: why.value.isEmpty ? null : why.value,
      how: how.value.isEmpty ? null : how.value,
      notes: notesInRequest,
    );
    return request;
  }

  void _addNoteChanges(List<ChangeChildEntity> childrenChanges) {
    List<CreateChild>? newNotes = _listCreatedNotes();
    List<UpdateChild>? updatedNotes = _listUpdatedNotes();
    List<DeleteChild>? deletedNotes = _listDeletedNotes();

    if (newNotes != null || updatedNotes != null || deletedNotes != null) {
      childrenChanges.add(
        ChangeChildEntity(
          createTypeName: 'CreateActivityNote',
          create: newNotes,
          update: updatedNotes,
          delete: deletedNotes,
        ),
      );
    }
  }

  List<CreateChild>? _listCreatedNotes() {
    List<CreateChild> createdNotes = [];
    for (ActivityNote note in notes.items) {
      if (note.isNew && note.isChanged) {
        var noteProperties = <EntityProperty>[
          EntityProperty(
            name: 'created',
            value: DataConversionModelToService.toISO8601DateTime(
              note.timestamp,
            ),
          ),
          EntityProperty(name: 'text', value: note.text.value),
        ];
        createdNotes.add(CreateChild(noteProperties));
      }
    }
    return (createdNotes.isNotEmpty) ? createdNotes : null;
  }

  List<UpdateChild>? _listUpdatedNotes() {
    List<UpdateChild>? updatedNotes = [];
    for (ActivityNote note in notes.items) {
      if (note.isNew == false && note.isChanged) {
        var updatedProperties = <EntityProperty>[
          EntityProperty(name: 'text', value: note.text.value),
        ];
        updatedNotes.add(UpdateChild(note.id, updatedProperties));
      }
    }
    return (updatedNotes.isNotEmpty) ? updatedNotes : null;
  }

  List<DeleteChild>? _listDeletedNotes() {
    List<DeleteChild>? deletedNotes = [];
    List<String> deletedNoteIds = notes.listDeletedNoteId();
    for (String id in deletedNoteIds) {
      deletedNotes.add(DeleteChild(id));
    }
    return (deletedNotes.isNotEmpty) ? deletedNotes : null;
  }

  //#endregion

  //#region FIELDS

  late final ModelPropertyChangeContext _context;
  ServiceClientActivities _serviceClient =
      GetIt.instance<ServiceClientActivities>();

  //#endregoin
}
