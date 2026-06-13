class PlayerEntity {
  int? id;
  String name;
  int number;
  int teamId;

  PlayerEntity({
    this.id,
    required this.name,
    required this.number,
    required this.teamId,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'number': number,
        'team_id': teamId,
      };

  static PlayerEntity fromMap(Map<String, dynamic> map) => PlayerEntity(
        id: map['id'],
        name: map['name'],
        number: map['number'],
        teamId: map['team_id'],
      );
}
