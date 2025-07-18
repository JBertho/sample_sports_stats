import 'package:sample_sport_stats/infrastructure/Entities/game_entity.dart';
import 'package:sample_sport_stats/infrastructure/Entities/quarter_entity.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/models/Quarter.dart';
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
  final List<Quarter> quarters;

  Game(
      {required this.opponentName,
      this.rank = "TO_DEFINE",
      this.atHome = true,
      this.teamScore = 0,
      this.opponentScore = 0,
      required this.teamPlayers,
      required this.substitutes,
      required this.opponentPlayer,
        required this.team,
        required this.quarters
      });

  static Game fromEntity(GameEntity game, Team team, List<QuarterEntity> quarters) {
    var finalQuarters = quarters.length < 4 ? _addEmptyQuarters(quarters) : quarters;
    return Game(
        opponentName: game.opponentName,
        opponentScore: game.opponentScore,
        teamScore: game.teamScore,
        teamPlayers: List.empty(),
        substitutes: List.empty(),
        atHome: game.atHome,
        team: team, opponentPlayer: MatchPlayer(name: game.opponentName, number: 0),
        quarters: finalQuarters.map((quarter) =>  Quarter.fromEntity(quarter)).toList());
  }

  int getQuarterTeamScore(int number) {
    var emptyQuarter = Quarter(teamScore: 0, opponentScore: 0, quarterNumber: 0, duration: Duration.zero);
    var quarter = quarters.firstWhere((quarter) => quarter.quarterNumber == number,
        orElse: () => emptyQuarter);

    return quarter.teamScore;
  }

  int getQuarterOpponentScore(int number) {
    var emptyQuarter = Quarter(teamScore: 0, opponentScore: 0, quarterNumber: 0, duration: Duration.zero);
    var quarter = quarters.firstWhere((quarter) => quarter.quarterNumber == number,
        orElse: () => emptyQuarter);

    return quarter.opponentScore;
  }

  static List<QuarterEntity> _addEmptyQuarters(List<QuarterEntity> quarters) {
    List<QuarterEntity> finalList = List<QuarterEntity>.from(quarters);
    for(int i = quarters.length;i < 4; i += 1) {
      finalList.add(QuarterEntity(gameId: 0, teamScore: 0, opponentScore: 0, quarterNumber: i, duration: const Duration()));
    }

    return finalList;
  }
}
