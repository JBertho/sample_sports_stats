import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/pages/currentGame/logic/CurrentGameCubit.dart';
import 'package:sample_sport_stats/pages/currentGame/logic/CurrentGameState.dart';
import 'package:sample_sport_stats/widgets/PlayerButton.dart';

import '../../models/Game.dart';
import '../../widgets/ActionButton.dart';

class CurrentMatchPage extends StatelessWidget {
  final Game game;

  const CurrentMatchPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentGameCubit>(
      create: (_) => CurrentGameCubit()..initGame(),
      child: _CurrentMatchPage(game: game),
    );
  }
}

class _CurrentMatchPage extends StatelessWidget {
  final Game game;

  const _CurrentMatchPage({required this.game});

  @override
  Widget build(BuildContext context) {
    var name = game.opponentName;
    var teamPlayers = game.teamPlayers;
    var opponentsPlayers = game.opponentPlayers;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Match en cours"),
        ),
        body: SafeArea(child: BlocBuilder<CurrentGameCubit, CurrentGameState>(
            builder: (context, state) {
              var atHomeValue = game.atHome ? 'à domicile' : 'à l\'exterieur';
          return Column(children: [
            Text("Contre $name $atHomeValue",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            if (state is CurrentGameInProgress)
              Text(
                "${state.teamScore} - ${state.opponentScore}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (state is CurrentGameInProgress)
              Expanded(
                  child: CurrentGame(
                state: state,
                teamPlayers: teamPlayers,
                opponentPlayers: opponentsPlayers,
              ))
          ]);
        })));
  }
}

class CurrentGame extends StatelessWidget {
  final CurrentGameInProgress state;
  final List<MatchPlayer> teamPlayers;
  final List<MatchPlayer> opponentPlayers;

  const CurrentGame(
      {super.key,
      required this.state,
      required this.teamPlayers,
      required this.opponentPlayers});

  @override
  Widget build(BuildContext context) {
    var actions = ActionGame.values;

    return Row(children: [
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: PlayerButton(
                            color: state.selectedPlayer != player
                                ? Colors.blue
                                : Colors.pink,
                            playerName: player.name,
                            playerNumber: player.number,
                            callback: () => {
                              context
                                  .read<CurrentGameCubit>()
                                  .selectPlayer(player)
                            },
                          )))
                      .toList()),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: opponentPlayers
                      .map((player) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: PlayerButton(
                            color: state.selectedPlayer != player
                                ? Colors.red
                                : Colors.pink,
                            playerName: player.name,
                            playerNumber: player.number,
                            callback: () => context
                                .read<CurrentGameCubit>()
                                .selectPlayer(player),
                          )))
                      .toList()),
            ],
          )),
      Expanded(
        flex: 30, // 30% de l'écran
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Historique',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.histories.length, // Nombre d'événements
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${state.histories[index].player.name} => ${state.histories[index].actionGame.name}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
          flex: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildActionRows(actions, context, state.selectedAction),
          ))
    ]);
  }

  List<Widget> _buildActionRows(List<ActionGame> actions, BuildContext context,
      ActionGame? selectedActionGame) {
    List<Widget> rows = [];

    var firstColumn = actions.sublist(0, actions.length ~/ 2);
    var lastColumn = actions.sublist(actions.length ~/ 2, actions.length);
    rows.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: firstColumn.map((action) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Actionbutton(
                text: action.name,
                color: selectedActionGame != action ? Colors.lime : Colors.pink,
                callback: () {
                  context.read<CurrentGameCubit>().selectActionGame(action);
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Actionbutton(
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('3 Colonnes Layout'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Colonne de gauche
                  Expanded(
                    flex: 35, // 35% de l'écran
                    child: Container(
                      color: Colors.blueAccent,
                    ),
                  ),
                  // Colonne du milieu
                  Expanded(
                    flex: 30, // 30% de l'écran
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Historique',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 10, // Nombre d'événements
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('Événement ${index + 1}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Colonne de droite
                  Expanded(
                    flex: 35, // 35% de l'écran
                    child: Container(
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
