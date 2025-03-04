class TeamEntity {
  int? id;
  String name;
  final String division;
  final String season;
  TeamEntity({this.id, required this.name, required this.division, required this.season});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'division': division,
      'season': season
    };
  }

  static TeamEntity fromMap(Map<String, dynamic> map) {
    return TeamEntity(
        id: map['id'],
        name: map['name'],
        division: map['division'],
        season: map['season']
    );
  }
}