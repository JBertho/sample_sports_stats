import 'package:flutter/cupertino.dart';
import 'package:sample_sport_stats/models/PlayerStats.dart';

import 'ActionGame.dart';

class MatchPlayer {
  final String name;
  final int number;
  int score;
  int fault;
  bool onTheBench;
  final PlayerStats playerStats = PlayerStats();

  MatchPlayer(
      {required this.name,
      required this.number,
      this.score = 0,
      this.fault = 0,
      this.onTheBench = false});

  void logStats() {
    final stats = playerStats.toMap();
    debugPrint('----- Player Stats : $name -----');
    stats.forEach((key, value) => debugPrint('$key: $value'));
    debugPrint('--------------------------');
  }

  void addPlayerStats(ActionGame actionGame) {
    _updatePlayerStats(actionGame, 1);
  }
  void revertPlayerStats(ActionGame actionGame) {
    _updatePlayerStats(actionGame, -1);
  }

  void _updatePlayerStats(ActionGame actionGame,int value) {
    switch(actionGame) {
      case ActionGame.twoPoint :
        playerStats.updateSuccessTwoPoint(value);
        break;
      case ActionGame.threePoint :
        playerStats.updateSuccessThreePoint(value);
        break;
      case ActionGame.freeThrow :
        playerStats.updateSuccessFreePoint(value);
        break;
      case ActionGame.fault :
        playerStats.updateFault(value);
        break;
      case ActionGame.failedTwoPoint :
        playerStats.updateFailedTwoPoint(value);
        break;
      case ActionGame.failedThreePoint :
        playerStats.updateFailedThreePoint(value);
        break;
      case ActionGame.failedFreeThrow :
        playerStats.updateFailedFreeThrow(value);
        break;
      case ActionGame.reboundOff :
        playerStats.updateReboundOff(value);
        break;
      case ActionGame.reboundDef :
        playerStats.updateReboundDef(value);
        break;
      case ActionGame.turnover :
        playerStats.updateTurnover(value);
        break;
      case ActionGame.interception :
        playerStats.updateInterception(value);
        break;
      case ActionGame.counter :
        playerStats.updateBlock(value);
        break;

    }
  }
}
