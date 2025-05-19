import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/infrastructure/DAO/game_dao.dart';
import 'package:sample_sport_stats/infrastructure/DAO/quarter_dao.dart';
import 'package:sample_sport_stats/infrastructure/Entities/game_entity.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/Team.dart';

import 'HistoriesState.dart';

class HistoriesCubit extends Cubit<HistoriesState> {
  final GameDAO gameDAO;
  final QuarterDao quarterDao;


  HistoriesCubit({required this.gameDAO, required this.quarterDao}) : super(InitTeamState());

  void initHistories(Team? team) async {
    if (team == null) {
      return;
    }
    var gameEntities = await gameDAO.getGamesByTeamId(team.id!);
    List<Game> games = [];
    for(GameEntity gameEntity in gameEntities) {
      var quartersByGame = await quarterDao.getQuartersByGame(gameEntity.id!);
       games.add(Game.fromEntity(gameEntity, team, quartersByGame));
    }

    emit(HistoriesTeamState(games));
  }

  void historyPressed(Game history) {
    emit(HistoryPressedState(state.games, history));
    emit(HistoriesTeamState(state.games));
  }
}
