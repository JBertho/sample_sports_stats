import 'package:sample_sport_stats/models/Player.dart';
import 'package:sample_sport_stats/models/Team.dart';

abstract class MatchState {
  final Team team;
  final List<Player> teamPlayers;
  final bool atHome;

  MatchState({required this.team, required this.teamPlayers, required this.atHome});
}

class MatchStateInitial extends MatchState{
  MatchStateInitial({ required super.team, required super.teamPlayers, required super.atHome});
}

class MatchStateInProgress extends MatchState{
  MatchStateInProgress({ required super.team, required super.teamPlayers, required super.atHome});
}

class BeginMatchState extends MatchState{
  final String opponentName;
  final List<Player> selectedPlayers;

  BeginMatchState({ required super.team, required super.teamPlayers, required super.atHome, required this.opponentName, required this.selectedPlayers});
}