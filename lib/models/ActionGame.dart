enum ActionGame {
  twoPoint(name: "2 points", type: ActionType.point, value: 2),
  threePoint(name: "3 points", type: ActionType.point, value: 3),
  freeThrow(name: "Lancer franc", type: ActionType.point, value: 1),
  fault(name: "Faute ", type: ActionType.fault),
  failedTwoPoint(name: "3 points raté ", type: ActionType.failedShot),
  failedThreePoint(name: "2 points raté ", type: ActionType.failedShot);



  final String name;
  final ActionType type;
  final int value;

  const ActionGame({required this.name, required this.type, this.value = 0});
}

enum ActionType {
  point,
  fault,
  failedShot,
}

