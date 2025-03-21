import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';

class History {
  final ActionGame actionGame;
  final MatchPlayer player;
  final MatchPlayer? opponent;
  final Duration elapsedTime;

  History({required this.actionGame, required this.player, this.opponent, required this.elapsedTime});
}