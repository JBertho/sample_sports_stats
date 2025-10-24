class PlayerStats {
  int score = 0;

  int failedFreeThrow = 0;
  int failedTwoPoint = 0;
  int failedThreePoint = 0;
  int successFreeThrow = 0;
  int successTwoPoint = 0;
  int successThreePoint = 0;

  int counter = 0;
  int block = 0;

  int reboundOff = 0;
  int reboundDef = 0;

  int fault = 0;
  int turnover = 0;
  int interception = 0;

  Map<String, int> toMap() {
    return {
      'score': score,
      'failedFreeThrow': failedFreeThrow,
      'failedTwoPoint': failedTwoPoint,
      'failedThreePoint': failedThreePoint,
      'successFreeThrow': successFreeThrow,
      'successTwoPoint': successTwoPoint,
      'successThreePoint': successThreePoint,
      'counter': counter,
      'block': block,
      'reboundOff': reboundOff,
      'reboundDef': reboundDef,
      'fault': fault,
      'turnover': turnover,
      'interception': interception,
    };
  }

  void updateSuccessFreePoint(int value) {
    score += value;
    successFreeThrow += value;
  }

  void updateSuccessTwoPoint(int value) {
    score += 2 * value;
    successTwoPoint += value;
  }

  void updateSuccessThreePoint(int value) {
    score += 3 * value;
    successThreePoint += value;
  }

  void updateFailedFreeThrow(int value) {
    failedFreeThrow += value;
  }

  void updateFailedTwoPoint(int value) {
    failedTwoPoint += value;
  }

  void updateFailedThreePoint(int value) {
    failedThreePoint += value;
  }

  void updateCounter(int value) {
    counter += value;
  }

  void updateBlock(int value) {
    block += value;
  }

  void updateReboundOff(int value) {
    reboundOff += value;
  }

  void updateReboundDef(int value) {
    reboundDef += value;
  }

  void updateFault(int value) {
    fault += value;
  }

  void updateTurnover(int value) {
    turnover += value;
  }

  void updateInterception(int value) {
    interception += value;
  }
}
