class DocumentCollections {
  static const String users = 'users';
  static const String work = 'work';
  static const String people = 'people';
  static const String activities = 'activities';
}

class UserProperties {
  static const String email = 'email';
  static const String password = 'password';
  static const String workTypes = 'workTypes';
}

class PeopleProperties {
  static const String userId = 'user_id';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
}

class WorkProperties {
  static const String userId = 'user_id';
  static const String name = 'name';
  static const String type = 'type';
  static const String what = 'what';
  static const String reference = 'reference';
  static const String archived = 'archived';
}

class ActivitiesProperties {
  static const String userId = 'user_id';
  static const String workId = 'work_id';
  static const String what = 'what';
  static const String state = 'state';
  static const String why = 'why';
  static const String how = 'how';
  static const String dueDate = 'dueDate';
}

