import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/Player.dart';

class History {
  final ActionGame actionGame;
  final Player player;
  final Player? opponent;

  History({required this.actionGame, required this.player, this.opponent});
}