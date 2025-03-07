import 'package:sample_sport_stats/models/Game.dart';

class GameEntity {
  int? id;
  String opponentName;
  int teamScore;
  int opponentScore;
  bool atHome;
  int teamId;

  GameEntity(
      {this.id,
      required this.opponentName,
      required this.opponentScore,
      required this.teamScore,
      required this.atHome,
      required this.teamId});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'opponent_name': opponentName,
      'team_score': teamScore,
      'opponent_score': opponentScore,
      'at_home': atHome ? 1 : 0,
      'team_id': teamId
    };
  }

  static GameEntity fromMap(Map<String, dynamic> map) {
    return GameEntity(
        id: map['id'],
        opponentName: map['opponent_name'],
        opponentScore: map['opponent_score'],
        teamScore: map['team_score'],
        atHome: map['at_home'] == 1,
        teamId: map['team_id']);
  }

  static GameEntity fromModel(Game game) {
    return GameEntity(
        opponentName: game.opponentName,
        opponentScore: game.opponentScore,
        teamScore: game.teamScore,
        atHome: game.atHome,
        teamId: game.team.id!);
  }
}
