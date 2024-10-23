import 'package:bloc/bloc.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/History.dart';
import 'package:sample_sport_stats/models/Player.dart';

import 'CurrentGameState.dart';

class CurrentGameCubit extends Cubit<CurrentGameState> {
  CurrentGameCubit()
      : super(CurrentGameInitial(
            histories: List.empty(), teamScore: 0, opponentScore: 0));

  void initGame() {
    emit(CurrentGameInProgress(
        teamScore: 0, opponentScore: 0, histories: List.empty()));
  }

  void selectPlayer(Player player) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedAction == null) {
      emit(CurrentGameInProgress(
          selectedPlayer: player,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          histories: currentState.histories));
    } else {
      saveAction(player, currentState.selectedAction!);
    }
  }

  void selectActionGame(ActionGame actionGame) {
    var currentState = state as CurrentGameInProgress;

    if (currentState.selectedPlayer == null) {
      emit(CurrentGameInProgress(
          selectedAction: actionGame,
          teamScore: currentState.teamScore,
          opponentScore: currentState.opponentScore,
          histories: currentState.histories));
    } else {
      saveAction(currentState.selectedPlayer!, actionGame);
    }
  }

  void saveAction(Player player, ActionGame actionGame) {
    var currentState = state as CurrentGameInProgress;

    var histories = currentState.histories;
    var history = History(actionGame: actionGame, player: player);
    var newHistories = List.of(histories);
    newHistories.add(history);

    if (actionGame.type == ActionType.point) {
      emit(CurrentGameInProgress(
          teamScore: currentState.teamScore + actionGame.value,
          opponentScore: currentState.opponentScore,
          histories: newHistories));
    }
  }
}
