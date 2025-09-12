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


  void addSuccessFreePoint() {
    _score += 1;
    _successFreeThrow += 1;
  }
  void addSuccessTwoPoint() {
    _score += 2;
    _successTwoPoint += 1;
  }
  void addSuccessThreePoint() {
    _score += 3;
    _successThreePoint += 1;
  }
  void addFailedFreeThrow() {
    _failedFreeThrow += 1;
  }
  void addFailedTwoPoint() {
    _failedTwoPoint += 1;
  }
  void addFailedThreePoint() {
    _failedThreePoint += 1;
  }
  void addCounter() {
    _counter += 1;
  }
  void addBlock() {
    _block += 1;
  }
  void addReboundOff() {
    _reboundOff += 1;
  }
  void addReboundDef() {
    _reboundDef += 1;
  }

  void addFault() {
    _fault += 1;
  }

  void addTurnover() {
    _turnover += 1;
  }
}