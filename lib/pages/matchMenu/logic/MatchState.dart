import 'package:sample_sport_stats/models/Player.dart';

abstract class MatchState {
  final List<Player> teamPlayers;

  MatchState({required this.teamPlayers});
}

class MatchStateInitial extends MatchState{
  MatchStateInitial({required super.teamPlayers});
}

class MatchStateInProgress extends MatchState{
  MatchStateInProgress({required super.teamPlayers});
}