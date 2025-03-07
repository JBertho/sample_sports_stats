import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/infrastructure/DAO/team_dao.dart';
import 'package:sample_sport_stats/infrastructure/Entities/team_entity.dart';
import 'package:sample_sport_stats/models/Team.dart';
import 'package:sample_sport_stats/pages/TeamsSelection/logic/TeamsSelectionState.dart';

class TeamSelectionCubit extends Cubit<TeamsSelectionState> {
  final TeamDao teamDao;

  TeamSelectionCubit(this.teamDao) : super(InitialTeamSelectionState());

  void initTeamSelection() async {
    var teams = await teamDao.getTeams();

    var teamSelection = teams.map((team) {
      return Team(
          id: team.id,
          name: team.name,
          division: team.division,
          season: team.season);
    }).toList();

    emit(TeamsSelectionView(teams: teamSelection));
  }

  void creationTeamPressed() {
    emit(TeamSelectionCreation(teams: state.teams));
    emit(TeamsSelectionView(teams: state.teams));
  }

  void createTeam(Team newTeam) async {
    TeamEntity teamEntity = TeamEntity(
        name: newTeam.name, division: newTeam.division, season: newTeam.season);
    var teamId = await teamDao.insertTeam(teamEntity);
    var createdTeam = Team(
        id: teamId,
        name: newTeam.name,
        division: newTeam.division,
        season: newTeam.season);
    state.teams.add(createdTeam);
    emit(TeamsSelectionView(teams: state.teams));
  }

  void selectTeam(Team team) {
    emit(SelectedTeamState(teams: state.teams, team: team));
  }

  Team? getTeam() {
    if(state is SelectedTeamState) {
       var currentState = state as SelectedTeamState;
      return currentState.team;
    }
    return null;
  }
}
