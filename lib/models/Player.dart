class Player {
  final int? id;
  final String name;
  final int number;
  bool selected;

  Player({this.id, required this.name, required this.number, this.selected = false});
}