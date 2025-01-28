enum ActionGame {
  twoPoint(name: "2 pts réussi", type: ActionType.point, value: 2),
  threePoint(name: "3 pts réussi", type: ActionType.point, value: 3),
  freeThrow(name: "Lancer franc réussi", type: ActionType.point, value: 1),
  fault(name: "Faute", type: ActionType.fault),
  failedTwoPoint(name: "3 pts raté ", type: ActionType.failedShot),
  failedThreePoint(name: "2 pts raté ", type: ActionType.failedShot),
  failedFreeThrow(name: "Lancer franc raté ", type: ActionType.failedShot),

  reboundOff(name: "Rebond Off", type: ActionType.rebound),
  reboundDef(name: "Rebond Def", type: ActionType.rebound),
  turnover(name: "Perte de balle", type: ActionType.turnover),
  interception(name: "Interception", type: ActionType.counter),
  block(name: "Contre", type: ActionType.counter);



  final String name;
  final ActionType type;
  final int value;

  const ActionGame({required this.name, required this.type, this.value = 0});
}

enum ActionType {
  point,
  fault,
  failedShot,
  rebound,
  turnover,
  counter
}

