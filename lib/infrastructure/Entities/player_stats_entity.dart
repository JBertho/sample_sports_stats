import 'package:sample_sport_stats/models/PlayerStats.dart';

class PlayerStatsEntity {
  int? id;
  int score;

  int failedFreeThrow;
  int failedTwoPoint;
  int failedThreePoint;
  int successFreeThrow;
  int successTwoPoint;
  int successThreePoint;

  int counter;
  int block;

  int reboundOff;
  int reboundDef;

  int fault;
  int turnover;
  int interception;

  int playerId;
  int gameId;

  PlayerStatsEntity({
    this.id,
    required this.score,
    required this.failedFreeThrow,
    required this.failedTwoPoint,
    required this.failedThreePoint,
    required this.successFreeThrow,
    required this.successTwoPoint,
    required this.successThreePoint,
    required this.counter,
    required this.block,
    required this.reboundOff,
    required this.reboundDef,
    required this.fault,
    required this.turnover,
    required this.interception,
    required this.playerId,
    required this.gameId
  });

  // 🔹 Conversion vers une Map (SQLite ou JSON)
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'score': score,
      'failed_free_throw': failedFreeThrow,
      'failed_two_point': failedTwoPoint,
      'failed_three_point': failedThreePoint,
      'success_free_throw': successFreeThrow,
      'success_two_point': successTwoPoint,
      'success_three_point': successThreePoint,
      'counter': counter,
      'block': block,
      'rebound_off': reboundOff,
      'rebound_def': reboundDef,
      'fault': fault,
      'turnover': turnover,
      'interception': interception,
      'player_id': playerId,
      'game_id': gameId
    };
  }

  // 🔹 Création depuis une Map (résultat SQLite)
  static PlayerStatsEntity fromMap(Map<String, dynamic> map) {
    return PlayerStatsEntity(
      id: map['id'],
      score: map['score'],
      failedFreeThrow: map['failed_free_throw'],
      failedTwoPoint: map['failed_two_point'],
      failedThreePoint: map['failed_three_point'],
      successFreeThrow: map['success_free_throw'],
      successTwoPoint: map['success_two_point'],
      successThreePoint: map['success_three_point'],
      counter: map['counter'],
      block: map['block'],
      reboundOff: map['rebound_off'],
      reboundDef: map['rebound_def'],
      fault: map['fault'],
      turnover: map['turnover'],
      interception: map['interception'],
      playerId: map['player_id'],
      gameId: map['game_id']
    );
  }

  static PlayerStatsEntity fromModel(
    PlayerStats stats, {
    required int playerId,
    required int gameId,
  }) {
    return PlayerStatsEntity(
        score: stats.score,
        failedFreeThrow: stats.failedFreeThrow,
        failedTwoPoint: stats.failedTwoPoint,
        failedThreePoint: stats.failedThreePoint,
        successFreeThrow: stats.successFreeThrow,
        successTwoPoint: stats.successTwoPoint,
        successThreePoint: stats.successThreePoint,
        counter: stats.counter,
        block: stats.block,
        reboundOff: stats.reboundOff,
        reboundDef: stats.reboundDef,
        fault: stats.fault,
        turnover: stats.turnover,
        interception: stats.interception,
        playerId: playerId,
        gameId: gameId);
  }
}
