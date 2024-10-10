import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_sport_stats/models/Opponent.dart';

class CurrentMatchpage extends StatelessWidget {
  final Opponent opponent;

  const CurrentMatchpage({super.key, required this.opponent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match en cours"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("Début du match")),
          const Text("Face à : "),
          Text(opponent.name),
          Text(opponent.rank)
        ],
      ),
    );
  }
}
