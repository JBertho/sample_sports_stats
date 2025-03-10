import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/models/Team.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchState.dart';

import '../../../models/Player.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit(): super(MatchStateInitial(team: Team(name: "", division: "", season: ""), teamPlayers: List.empty(), atHome: true));


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

  void initGame(Team team) {
    emit(MatchStateInProgress(team: team, teamPlayers: teamPlayers, atHome: true));
  }

  void selectPlayer(Player player) {
    bool contains = teamPlayers.contains(player);

    if(contains) {
      teamPlayers.firstWhere((pl) => pl.name == player.name && pl.number == player.number).selected = true;
      emit(MatchStateInProgress(team: state.team, teamPlayers: teamPlayers, atHome: state.atHome));
    }
  }

  void unselectPlayer(Player player) {
    bool contains = teamPlayers.contains(player);
    if(contains) {
      teamPlayers.firstWhere((pl) => pl.name == player.name && pl.number == player.number).selected = false;
    }
    emit(MatchStateInProgress(team: state.team, teamPlayers: teamPlayers, atHome: state.atHome));
  }

  void updateAtHome() {
    emit(MatchStateInProgress(team: state.team, teamPlayers: state.teamPlayers, atHome: !state.atHome));

  }

  void beginMatch(String opponentName) {
    var selectedList = state.teamPlayers.where((player) => player.selected).toList();
    emit(BeginMatchState(team: state.team, teamPlayers: state.teamPlayers, atHome: state.atHome, opponentName: opponentName, selectedPlayers: selectedList));
    emit(MatchStateInProgress(team: state.team, teamPlayers: state.teamPlayers, atHome: state.atHome));
  }
}