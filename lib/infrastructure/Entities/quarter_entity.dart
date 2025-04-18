class QuarterEntity {
  final int gameId;
  final int teamScore;
  final int opponentScore;
  final int quarterNumber;
  final Duration duration;

  QuarterEntity(
      {required this.gameId,
      required this.teamScore,
      required this.opponentScore,
      required this.quarterNumber,
      required this.duration});
}
