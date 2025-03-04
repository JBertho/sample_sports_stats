import 'package:sample_sport_stats/models/Team.dart';

abstract class TeamsSelectionState {
  final List<Team> teams;

  TeamsSelectionState({required this.teams});
}

class InitialTeamSelectionState extends TeamsSelectionState {
  InitialTeamSelectionState(): super(teams: []);
}

class TeamsSelectionView extends TeamsSelectionState {
  TeamsSelectionView({required super.teams});
}

class TeamSelectionCreation extends TeamsSelectionState {
  TeamSelectionCreation({required super.teams});
}
