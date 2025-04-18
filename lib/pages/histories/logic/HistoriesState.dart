import 'package:sample_sport_stats/models/Game.dart';

abstract class HistoriesState {
  List<Game> games;

  HistoriesState(this.games);
}

class InitTeamState extends HistoriesState {
  InitTeamState(): super(List.empty());

}

class HistoriesTeamState extends HistoriesState {
  HistoriesTeamState(super.games);

}


class HistoryPressedState extends HistoriesState {
  final Game game;
  HistoryPressedState(super.games, this.game);

}

