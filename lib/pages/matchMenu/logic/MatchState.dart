import 'package:sample_sport_stats/models/Player.dart';

abstract class MatchState {
  final List<Player> teamPlayers;
  final bool atHome;

  MatchState({required this.teamPlayers, required this.atHome});
}

class MatchStateInitial extends MatchState{
  MatchStateInitial({required super.teamPlayers, required super.atHome});
}

class MatchStateInProgress extends MatchState{
  MatchStateInProgress({required super.teamPlayers, required super.atHome});
}

class BeginMatchState extends MatchState{
  final String opponentName;
  final List<Player> selectedPlayers;

  BeginMatchState({required super.teamPlayers, required super.atHome, required this.opponentName, required this.selectedPlayers});
}