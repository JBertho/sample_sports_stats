import 'package:sample_sport_stats/infrastructure/Entities/game_entity.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/models/Team.dart';

class Game {
  final String opponentName;
  final String rank;
  final bool atHome;
  int teamScore;
  int opponentScore;
  final List<MatchPlayer> teamPlayers;
  final List<MatchPlayer> substitutes;
  final MatchPlayer opponentPlayer;
  final Team team;

  Game(
      {required this.opponentName,
      this.rank = "TO_DEFINE",
      this.atHome = true,
      this.teamScore = 0,
      this.opponentScore = 0,
      required this.teamPlayers,
      required this.substitutes,
      required this.opponentPlayer,
        required this.team
      });

  static Game fromEntity(GameEntity game, Team team) {
    return Game(
        opponentName: game.opponentName,
        opponentScore: game.opponentScore,
        teamScore: game.teamScore,
        teamPlayers: List.empty(),
        substitutes: List.empty(),
        atHome: game.atHome,
        team: team, opponentPlayer: MatchPlayer(name: game.opponentName, number: 0));
  }
}
