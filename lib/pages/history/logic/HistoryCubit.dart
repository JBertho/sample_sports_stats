import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/infrastructure/DAO/game_dao.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/Team.dart';
import 'package:sample_sport_stats/pages/history/logic/HistoryState.dart';

class HistoryCubit extends Cubit<HistoryState> {

  final GameDAO gameDAO;

  HistoryCubit({required this.gameDAO}): super(InitTeamState());

  void initHistory(Team? team) async {
    if(team == null) {
      return;
    }
    var gameEntities = await gameDAO.getGamesByTeamId(team.id!);
    var games = gameEntities.map((gameEntity) => Game.fromEntity(gameEntity, team)).toList();
    log("[DEBUGG GAMES] $games");
    emit(HistoryTeamState(games));

  }
}
