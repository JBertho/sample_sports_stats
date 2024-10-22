import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/widgets/PlayerButton.dart';

import '../models/Game.dart';
import '../widgets/ActionButton.dart';

class CurrentMatchpage extends StatefulWidget {
  final Game game;

  const CurrentMatchpage({super.key, required this.game});

  @override
  State<StatefulWidget> createState() {
    return CurrentMatchpageState();
  }
}

class CurrentMatchpageState extends State<CurrentMatchpage> {
  @override
  Widget build(BuildContext context) {
    var name = widget.game.opponentName;
    var teamScore = widget.game.teamScore;
    var opponentScore = widget.game.opponentScore;
    var teamPlayers = widget.game.teamPlayers;
    var opponentsPlayers = widget.game.opponentPlayers;

    var actions = ActionGame.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Match en cours"),
      ),
      body: Column(children: [
        Text("Contre $name",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        Text(
          "$teamScore - $opponentScore",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
                flex: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: teamPlayers
                            .map((player) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: PlayerButton(
                                  color: Colors.blue,
                                  playerName: player.name,
                                  playerNumber: player.number,
                                )))
                            .toList()),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: opponentsPlayers
                            .map((player) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: PlayerButton(
                                  color: Colors.red,
                                  playerName: player.name,
                                  playerNumber: player.number,
                                )))
                            .toList()),
                  ],
                )),
            Expanded(
              flex: 30,
              child: Container(
                color: Colors.green, // Couleur de fond pour la visualisation (optionnel)
                child: Column(
                  children: [
                    // Texte en haut
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Historique des actions :",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildActionRows(actions),))
      ])])
    );
  }

  List<Widget> _buildActionRows(List<ActionGame> actions) {
    List<Widget> rows = [];

    var firstColumn = actions.sublist(0,  actions.length ~/ 2);
    var lastColumn = actions.sublist(actions.length ~/ 2,  actions.length);
    rows.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: firstColumn.map((action) {
          return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10),
              child:Actionbutton(
                text: action.name,
                color: Colors.lime,
                callback: () {
                  if (action.type == ActionType.point) {
                    log("PANIER");
                  }
                  if (action.type == ActionType.failedShot) {
                    log("RATE");
                  }
                  if (action.type == ActionType.fault) {
                    log("FAUTE");
                  }
                },
              ));
        }).toList(),
      ),
    );

    rows.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: lastColumn.map((action) {
          return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10),
              child:Actionbutton(
                text: action.name,
                color: Colors.lime,
                callback: () {
                  if (action.type == ActionType.point) {
                    log("PANIER");
                  }
                  if (action.type == ActionType.failedShot) {
                    log("RATE");
                  }
                  if (action.type == ActionType.fault) {
                    log("FAUTE");
                  }
                },
              ));
        }).toList(),
      ),
    );

    return rows;
  }

}
