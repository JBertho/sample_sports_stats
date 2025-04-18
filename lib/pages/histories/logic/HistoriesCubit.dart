import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/infrastructure/DAO/game_dao.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/Team.dart';

import 'HistoriesState.dart';

class HistoriesCubit extends Cubit<HistoriesState> {
  final GameDAO gameDAO;

  HistoriesCubit({required this.gameDAO}) : super(InitTeamState());

  void initHistories(Team? team) async {
    if (team == null) {
      return;
    }
    var gameEntities = await gameDAO.getGamesByTeamId(team.id!);
    var games = gameEntities
        .map((gameEntity) => Game.fromEntity(gameEntity, team, List.empty()))
        .toList();

    emit(HistoriesTeamState(games));
  }

  void historyPressed(Game history) {
    emit(HistoryPressedState(state.games, history));
    emit(HistoriesTeamState(state.games));
  }
}
