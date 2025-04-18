import 'package:sample_sport_stats/infrastructure/Entities/quarter_entity.dart';

class Quarter {
  final int teamScore;
  final int opponentScore;
  final int quarterNumber;
  final Duration duration;

  Quarter(
      {required this.teamScore,
      required this.opponentScore,
      required this.quarterNumber,
      required this.duration});

  @override
  String toString() {
    return 'Quarter{teamScore: $teamScore, opponentScore: $opponentScore, quarterNumber: $quarterNumber, duration: $duration}';
  }

  static Quarter fromEntity(QuarterEntity quarter) {
    return Quarter(
        teamScore: quarter.teamScore,
        opponentScore: quarter.opponentScore,
        quarterNumber: quarter.quarterNumber,
        duration: quarter.duration);
  }
}
