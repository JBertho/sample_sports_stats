class Player {
  final String name;
  final int number;
  int score;
  int fault;
  bool onTheBench;

  Player({required this.name, required this.number, this.score = 0, this.fault = 0, this.onTheBench = false});
}