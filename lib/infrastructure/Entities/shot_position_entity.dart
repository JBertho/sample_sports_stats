import 'package:sample_sport_stats/models/ActionGame.dart';

class ShotPositionEntity {
  int? id;
  int gameId;
  int playerId;
  String actionType;
  double shotX;
  double shotY;
  int elapsedTimeMs;

  ShotPositionEntity({
    this.id,
    required this.gameId,
    required this.playerId,
    required this.actionType,
    required this.shotX,
    required this.shotY,
    required this.elapsedTimeMs,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'player_id': playerId,
      'action_type': actionType,
      'shot_x': shotX,
      'shot_y': shotY,
      'elapsed_time': elapsedTimeMs,
    };
  }

  static ShotPositionEntity fromMap(Map<String, dynamic> map) {
    return ShotPositionEntity(
      id: map['id'],
      gameId: map['game_id'],
      playerId: map['player_id'],
      actionType: map['action_type'],
      shotX: (map['shot_x'] as num).toDouble(),
      shotY: (map['shot_y'] as num).toDouble(),
      elapsedTimeMs: map['elapsed_time'],
    );
  }

  ActionGame get action =>
      ActionGame.values.firstWhere((a) => a.name == actionType);
}
