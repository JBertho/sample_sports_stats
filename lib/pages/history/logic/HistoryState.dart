import 'package:sample_sport_stats/models/Game.dart';

abstract class HistoryState {
  List<Game> games;

  HistoryState(this.games);
}

class InitTeamState extends HistoryState {
  InitTeamState(): super(List.empty());

}

class HistoryTeamState extends HistoryState {
  HistoryTeamState(super.games);

}