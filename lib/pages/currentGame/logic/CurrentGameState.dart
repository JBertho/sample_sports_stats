import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/History.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';

abstract class CurrentGameState {
  int teamScore;
  int opponentScore;

  //final List<Player> teamPlayers;
  //final List<Player> opponentPlayers;
  final List<History> histories;

  CurrentGameState(
      {required this.teamScore,
      required this.opponentScore,
      required this.histories});
}

class CurrentGameInitial extends CurrentGameState {
  CurrentGameInitial(
      {required super.histories,
      required super.teamScore,
      required super.opponentScore});
}

class CurrentGameInProgress extends CurrentGameState {
  final MatchPlayer? selectedPlayer;
  final ActionGame? selectedAction;
  final MatchPlayer? selectedOpponentPlayer;

  CurrentGameInProgress(
      {this.selectedPlayer,
      this.selectedAction,
      this.selectedOpponentPlayer,
      required super.teamScore,
      required super.opponentScore,
      required super.histories});
}
