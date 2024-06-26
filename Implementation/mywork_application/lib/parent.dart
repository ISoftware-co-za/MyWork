class Parent {
  int id;
  String name;

  Parent({required this.id, required this.name});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      name: json['name'],
    );
  }
}
