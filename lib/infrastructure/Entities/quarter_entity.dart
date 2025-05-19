import 'package:sample_sport_stats/models/Quarter.dart';

class QuarterEntity {
  final int? id;
  final int gameId;
  final int teamScore;
  final int opponentScore;
  final int quarterNumber;
  final Duration duration;

  QuarterEntity(
      {this.id,
      required this.gameId,
      required this.teamScore,
      required this.opponentScore,
      required this.quarterNumber,
      required this.duration});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'team_score': teamScore,
      'opponent_score': opponentScore,
      'quarter_number': quarterNumber,
      'duration': duration.inMilliseconds
    };
  }

  static QuarterEntity fromMap(Map<String, dynamic> map) {
    return QuarterEntity(
        id: map["id"],
        gameId: map["game_id"],
        teamScore: map["team_score"],
        opponentScore: map["opponent_score"],
        quarterNumber: map["quarter_number"],
        duration: Duration(milliseconds: map["duration"]));
  }

  static QuarterEntity fromModelWithGameId(Quarter quarter, int gameId) {
    return QuarterEntity(
        gameId: gameId,
        teamScore: quarter.teamScore,
        opponentScore: quarter.opponentScore,
        quarterNumber: quarter.quarterNumber,
        duration: quarter.duration);
  }

  @override
  String toString() {
    return 'QuarterEntity{id: $id, gameId: $gameId, teamScore: $teamScore, opponentScore: $opponentScore, quarterNumber: $quarterNumber, duration: $duration}';
  }
}
