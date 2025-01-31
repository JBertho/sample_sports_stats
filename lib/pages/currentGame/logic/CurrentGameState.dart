import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/History.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';

abstract class CurrentGameState {
  int teamScore;
  int opponentScore;
  final bool atHome;
  final MatchPlayer opponent;

  final List<MatchPlayer> teamPlayers;
  final List<MatchPlayer> substitutes;
  final List<History> histories;

  CurrentGameState(
      {required this.teamScore,
      required this.opponentScore,
      required this.histories,
      required this.opponent,
      required this.teamPlayers,
      required this.substitutes,
        required this.atHome
      });
}

class CurrentGameInitial extends CurrentGameState {
  CurrentGameInitial(
      {required super.histories,
      required super.opponent,
      required super.teamScore,
      required super.opponentScore,
      required super.teamPlayers,
      required super.substitutes,
      required super.atHome});
}

class CurrentGameInProgress extends CurrentGameState {
  final MatchPlayer? selectedPlayer;
  final ActionGame? selectedAction;
  final MatchPlayer? selectedOpponentPlayer;
  final MatchPlayer? selectedSubPlayer;

  CurrentGameInProgress(
      {this.selectedPlayer,
      this.selectedAction,
      this.selectedOpponentPlayer,
        this.selectedSubPlayer,
      required super.teamScore,
      required super.opponentScore,
      required super.histories,
      required super.opponent,
      required super.teamPlayers,
      required super.substitutes,
        required super.atHome});
}
