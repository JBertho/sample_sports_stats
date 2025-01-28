import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/History.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';

import 'CurrentGameState.dart';

class CurrentGameCubit extends Cubit<CurrentGameState> {
  CurrentGameCubit()
      : super(CurrentGameInitial(
            histories: List.empty(), teamScore: 0, opponentScore: 0));

  void initGame() {
    emit(CurrentGameInProgress(
        teamScore: 0, opponentScore: 0, histories: List.empty()));
  }

  void selectPlayer(MatchPlayer player, Duration elapsedTime) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedAction == null) {
      emit(CurrentGameInProgress(
          selectedPlayer: player,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          histories: currentState.histories));
    } else {
      saveAction(player, currentState.selectedAction!, elapsedTime);
    }
  }

  void selectActionGame(ActionGame actionGame, Duration elapsedTime) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedPlayer == null) {
      emit(CurrentGameInProgress(
          selectedAction: actionGame,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          histories: currentState.histories));
    } else {
      saveAction(currentState.selectedPlayer!, actionGame, elapsedTime);
    }
  }

  void saveAction(MatchPlayer player, ActionGame actionGame, Duration elapsedTime) {
    log("SAVINNG");
    var currentState = state as CurrentGameInProgress;

    var histories = currentState.histories;
    var history = History(actionGame: actionGame, player: player, elapsedTime: elapsedTime);
    var newHistories = List.of(histories);
    newHistories.add(history);

    switch(actionGame.type) {
      case ActionType.point:
        currentState.teamScore = currentState.teamScore + actionGame.value;
        break;
      case ActionType.fault:
        //add fault
        break;
      case ActionType.failedShot:
        //handle background stats
      case ActionType.rebound:
        //handle background stats
      case ActionType.turnover:
        //handle background stats
      case ActionType.counter:
        //handle background stats
    }
    emit(CurrentGameInProgress(
        teamScore: currentState.teamScore,
        opponentScore: currentState.opponentScore,
        histories: newHistories));
  }

  void deleteHistory(History history) {
    var currentState = state as CurrentGameInProgress;
    var histories = currentState.histories;

    var containHistory = histories.contains(history);
    if(containHistory) {
      histories.remove(history);
      emit(CurrentGameInProgress(
          selectedAction: currentState.selectedAction,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          histories: histories));
    }
  }
}
