import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/Player.dart';

import '../router/routes.dart';

class MatchPage extends StatelessWidget {

  final Game game = Game(opponentName: "Charly Bertho", teamPlayers: [
    Player(name: "Jamso", number: 1),
    Player(name: "Carlito", number: 14),
    Player(name: "Jean", number: 5),
    Player(name: "Paul", number: 231),
    Player(name: "Claude", number: 4),
  ], opponentPlayers: [
    Player(name: "Leona", number: 8),
    Player(name: "Ezreal", number: 16),
    Player(name: "K'Santé", number: 48),
    Player(name: "Lux", number: 32),
    Player(name: "Kindred", number: 2),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MATCH"),),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Commencer un match "),
        ElevatedButton(
            onPressed: () {
              context.push(Routes.nestedCurrentMatchPage,
              extra: game);
            },
            child: const Text("Start game"))
      ],
    )));
  }
}
