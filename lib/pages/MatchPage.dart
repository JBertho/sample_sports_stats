import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/LayoutScaffold.dart';
import 'package:sample_sport_stats/models/Opponent.dart';

import '../router/routes.dart';

class MatchPage extends StatelessWidget {

  final Opponent opponent = const Opponent(name: "Charly Bertho", rank: "15");

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
              extra: opponent);
            },
            child: const Text("Start game"))
      ],
    )));
  }
}
