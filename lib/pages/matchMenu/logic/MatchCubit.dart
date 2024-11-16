import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchState.dart';

import '../../../models/Player.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit(): super(MatchStateInitial(teamPlayers: List.empty()));

  final List<Player> teamPlayers = [
    Player(name: "Jamso", number: 1),
    Player(name: "Carlito", number: 14),
    Player(name: "Jean", number: 5),
    Player(name: "Paul", number: 231),
    Player(name: "Claude", number: 4),
    Player(name: "Jimmy", number: 2),
    Player(name: "Ali", number: 8),
    Player(name: "Max", number: 12),
    Player(name: "Guillaume", number: 23),
    Player(name: "Charles", number: 18),
  ];

  void initGame() {
    emit(MatchStateInProgress(teamPlayers: teamPlayers));
  }

  void selectPlayer(Player player) {
    bool contains = teamPlayers.contains(player);
    if(!contains) {
      //TODO
    } else if(teamPlayers.where((pl) => pl.selected).length >= 5) {
     //TODO
    } else {
      teamPlayers.firstWhere((pl) => pl.name == player.name && pl.number == player.number).selected = true;
      emit(MatchStateInProgress(teamPlayers: teamPlayers));
    }
  }

  void unselectPlayer(Player player) {
    bool contains = teamPlayers.contains(player);
    if(!contains) {
      //TODO
    } else {
      teamPlayers.firstWhere((pl) => pl.name == player.name && pl.number == player.number).selected = false;
      emit(MatchStateInProgress(teamPlayers: teamPlayers));
    }
  }
}