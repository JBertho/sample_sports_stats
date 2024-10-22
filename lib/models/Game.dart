import 'package:sample_sport_stats/models/Player.dart';

class Game {
  final String opponentName;
  final String rank;
  int teamScore;
  int opponentScore;
  final List<Player> teamPlayers;
  final List<Player> opponentPlayers;

  Game({required this.opponentName, this.rank = "TO_DEFINE", this.teamScore = 0, this.opponentScore = 0, required this.teamPlayers, required this.opponentPlayers});
}