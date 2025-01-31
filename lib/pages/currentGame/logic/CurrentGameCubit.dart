import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/History.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';

import 'CurrentGameState.dart';

class CurrentGameCubit extends Cubit<CurrentGameState> {
  CurrentGameCubit()
      : super(CurrentGameInitial(
            histories: List.empty(),
            teamScore: 0,
            opponentScore: 0,
            opponent: MatchPlayer(name: "opponent", number: 0),
            teamPlayers: List.empty(),
            substitutes: List.empty(),
            atHome: true));

  void initGame(Game game) {
    emit(CurrentGameInProgress(
        teamScore: 0,
        opponentScore: 0,
        histories: List.empty(),
        opponent: MatchPlayer(name: game.opponentName, number: 0),
        teamPlayers: game.teamPlayers,
        substitutes: game.substitutes,
        atHome: game.atHome));
  }

  void selectPlayer(MatchPlayer player, Duration elapsedTime) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedAction == null && currentState.selectedSubPlayer == null) {
      emit(CurrentGameInProgress(
          selectedPlayer: player,
          teamScore: currentState.teamScore,
          opponent: currentState.opponent,
          opponentScore: currentState.opponentScore,
          histories: currentState.histories,
          teamPlayers: currentState.teamPlayers,
          substitutes: currentState.substitutes,
          atHome: currentState.atHome));
    } else if(currentState.selectedAction != null){
      saveAction(player, currentState.selectedAction!, elapsedTime);
    } else if(currentState.selectedSubPlayer != null){
      substitutePlayer(player, currentState.selectedSubPlayer!);
    }
  }

  void selectSub(MatchPlayer player, Duration elapsedTime) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedPlayer == null) {
      emit(CurrentGameInProgress(
          selectedSubPlayer: player,
          teamScore: currentState.teamScore,
          opponent: currentState.opponent,
          opponentScore: currentState.opponentScore,
          histories: currentState.histories,
          teamPlayers: currentState.teamPlayers,
          substitutes: currentState.substitutes,
          atHome: currentState.atHome));
    } else {
      substitutePlayer(currentState.selectedPlayer!, player);
    }
  }


  void selectActionGame(ActionGame actionGame, Duration elapsedTime) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedPlayer == null &&
        currentState.selectedOpponentPlayer == null) {
      emit(CurrentGameInProgress(
          selectedAction: actionGame,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          opponent: currentState.opponent,
          histories: currentState.histories,
          teamPlayers: currentState.teamPlayers,
          substitutes: currentState.substitutes,
          atHome: currentState.atHome));
    } else if (currentState.selectedOpponentPlayer != null) {
      saveAction(currentState.selectedOpponentPlayer!, actionGame, elapsedTime);
    } else {
      saveAction(currentState.selectedPlayer!, actionGame, elapsedTime);
    }
  }

  void substitutePlayer(MatchPlayer player, MatchPlayer substitute) {
    var currentState = state as CurrentGameInProgress;

    var subIndex = currentState.substitutes.indexOf(substitute);
    currentState.substitutes[subIndex] = player;

    var playerIndex = currentState.teamPlayers.indexOf(player);
    currentState.teamPlayers[playerIndex] = substitute;

    emit(CurrentGameInProgress(
        teamScore: currentState.teamScore,
        opponentScore: currentState.opponentScore,
        opponent: currentState.opponent,
        histories: currentState.histories,
        teamPlayers: currentState.teamPlayers,
        substitutes: currentState.substitutes,
        atHome: currentState.atHome));
  }

  void saveAction(
      MatchPlayer player, ActionGame actionGame, Duration elapsedTime) {
    var currentState = state as CurrentGameInProgress;

    var histories = currentState.histories;
    var history = History(
        actionGame: actionGame, player: player, elapsedTime: elapsedTime);
    var newHistories = List.of(histories);
    newHistories.add(history);

    switch (actionGame.type) {
      case ActionType.point:
        if (player == state.opponent) {
          currentState.opponentScore =
              currentState.opponentScore + actionGame.value;
          currentState.opponent.score =
              currentState.opponent.score + actionGame.value;
        } else {
          currentState.teamScore = currentState.teamScore + actionGame.value;
        }
        break;
      case ActionType.fault:
        if (history.player.fault < 5) {
          player.fault += 1;
        }
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
        opponent: currentState.opponent,
        histories: newHistories,
        teamPlayers: currentState.teamPlayers,
        substitutes: currentState.substitutes,
        atHome: currentState.atHome));
  }

  void deleteHistory(History history) {
    var currentState = state as CurrentGameInProgress;
    var histories = currentState.histories;

    var containHistory = histories.contains(history);
    if (containHistory) {
      switch (history.actionGame.type) {
        case ActionType.point:
          if (history.player == currentState.opponent) {
            currentState.opponentScore =
                currentState.opponentScore - history.actionGame.value;
            currentState.opponent.score =
                currentState.opponent.score - history.actionGame.value;
          } else {
            currentState.teamScore =
                currentState.teamScore - history.actionGame.value;
          }
          break;
        case ActionType.fault:
          if (history.player.fault > 0) {
            history.player.fault -= 1;
          }
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

      histories.remove(history);
      emit(CurrentGameInProgress(
          selectedAction: currentState.selectedAction,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          opponent: currentState.opponent,
          histories: histories,
          teamPlayers: currentState.teamPlayers,
          substitutes: currentState.substitutes,
          atHome: currentState.atHome));
    }
  }
}
