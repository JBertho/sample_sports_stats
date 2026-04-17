import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';

class History {
  final ActionGame actionGame;
  final MatchPlayer player;
  final MatchPlayer? opponent;
  final Duration elapsedTime;

  // Coordonnées relatives (0.0 à 1.0) - nulles si l'action n'est pas un tir
  final double? shotX;
  final double? shotY;

  History({
    required this.actionGame,
    required this.player,
    this.opponent,
    required this.elapsedTime,
    this.shotX,
    this.shotY,
  });
}