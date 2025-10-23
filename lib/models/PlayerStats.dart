class PlayerStats {
  int _score = 0;

  int _failedFreeThrow = 0;
  int _failedTwoPoint = 0;
  int _failedThreePoint = 0;
  int _successFreeThrow = 0;
  int _successTwoPoint = 0;
  int _successThreePoint = 0;

  int _counter = 0;
  int _block = 0;

  int _reboundOff = 0;
  int _reboundDef = 0;

  int _fault = 0;
  int _turnover = 0;
  int _interception = 0;

  Map<String, int> toMap() {
    return {
      'score': _score,
      'failedFreeThrow': _failedFreeThrow,
      'failedTwoPoint': _failedTwoPoint,
      'failedThreePoint': _failedThreePoint,
      'successFreeThrow': _successFreeThrow,
      'successTwoPoint': _successTwoPoint,
      'successThreePoint': _successThreePoint,
      'counter': _counter,
      'block': _block,
      'reboundOff': _reboundOff,
      'reboundDef': _reboundDef,
      'fault': _fault,
      'turnover': _turnover,
      'interception': _interception,
    };
  }

  void updateSuccessFreePoint(int value) {
    _score += value;
    _successFreeThrow += value;
  }

  void updateSuccessTwoPoint(int value) {
    _score += 2 * value;
    _successTwoPoint += value;
  }

  void updateSuccessThreePoint(int value) {
    _score += 3 * value;
    _successThreePoint += value;
  }

  void updateFailedFreeThrow(int value) {
    _failedFreeThrow += value;
  }

  void updateFailedTwoPoint(int value) {
    _failedTwoPoint += value;
  }

  void updateFailedThreePoint(int value) {
    _failedThreePoint += value;
  }

  void updateCounter(int value) {
    _counter += value;
  }

  void updateBlock(int value) {
    _block += value;
  }

  void updateReboundOff(int value) {
    _reboundOff += value;
  }

  void updateReboundDef(int value) {
    _reboundDef += value;
  }

  void updateFault(int value) {
    _fault += value;
  }

  void updateTurnover(int value) {
    _turnover += value;
  }

  void updateInterception(int value) {
    _interception += value;
  }
}
