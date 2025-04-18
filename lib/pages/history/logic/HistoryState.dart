import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/models/Team.dart';

abstract class HistoryState {
  Game game;

  HistoryState(this.game);
}

class InitHistoryState extends HistoryState {
  InitHistoryState(): super(Game(opponentName: "", teamPlayers: List.empty(), substitutes: List.empty(), opponentPlayer: MatchPlayer(name: "", number: 0), team: Team(name: "", division: "", season: ""), quarters: []));

}

class DisplayHistoryState extends HistoryState {
  DisplayHistoryState(super.game);

}