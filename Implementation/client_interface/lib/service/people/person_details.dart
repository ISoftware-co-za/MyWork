class PersonDetails {
  String firstName;
  String lastName;
  PersonDetails(this.firstName, this.lastName);

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}