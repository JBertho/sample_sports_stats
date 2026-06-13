import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/infrastructure/DAO/player_dao.dart';
import 'package:sample_sport_stats/infrastructure/Entities/player_entity.dart';
import 'package:sample_sport_stats/models/Player.dart';
import 'package:sample_sport_stats/models/Team.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchState.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit()
      : super(MatchStateInitial(
            team: Team(name: '', division: '', season: ''),
            teamPlayers: [],
            atHome: true));

  void initGame(Team team) async {
    final entities = await PlayerDAO().getPlayersByTeamId(team.id!);
    final players = entities
        .map((e) => Player(id: e.id, name: e.name, number: e.number))
        .toList();
    emit(MatchStateInProgress(team: team, teamPlayers: players, atHome: true));
  }

  Future<void> addPlayer(String name, int number) async {
    final entity = PlayerEntity(
      name: name,
      number: number,
      teamId: state.team.id!,
    );
    final id = await PlayerDAO().insertPlayer(entity);
    final newPlayer = Player(id: id, name: name, number: number);
    final updated = List<Player>.from(state.teamPlayers)..add(newPlayer);
    emit(MatchStateInProgress(
        team: state.team, teamPlayers: updated, atHome: state.atHome));
  }

  void selectPlayer(Player player) {
    final selectedCount = state.teamPlayers.where((p) => p.selected).length;
    if (selectedCount >= 5) return;

    final players = state.teamPlayers;
    try {
      players
          .firstWhere((pl) => pl.number == player.number)
          .selected = true;
    } catch (_) {
      return;
    }
    emit(MatchStateInProgress(
        team: state.team, teamPlayers: players, atHome: state.atHome));
  }

  void unselectPlayer(Player player) {
    final players = state.teamPlayers;
    try {
      players
          .firstWhere((pl) => pl.number == player.number)
          .selected = false;
    } catch (_) {}
    emit(MatchStateInProgress(
        team: state.team, teamPlayers: players, atHome: state.atHome));
  }

  void updateAtHome() {
    emit(MatchStateInProgress(
        team: state.team,
        teamPlayers: state.teamPlayers,
        atHome: !state.atHome));
  }

  void beginMatch(String opponentName) {
    final selectedList =
        state.teamPlayers.where((player) => player.selected).toList();
    emit(BeginMatchState(
        team: state.team,
        teamPlayers: state.teamPlayers,
        atHome: state.atHome,
        opponentName: opponentName,
        selectedPlayers: selectedList));
    emit(MatchStateInProgress(
        team: state.team,
        teamPlayers: state.teamPlayers,
        atHome: state.atHome));
  }
}
