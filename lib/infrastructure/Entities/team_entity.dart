class TeamEntity {
  int? id;
  String name;
  TeamEntity({this.id, required this.name});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  static TeamEntity fromMap(Map<String, dynamic> map) {
    return TeamEntity(
        id: map['id'],
        name: map['name']);
  }
}