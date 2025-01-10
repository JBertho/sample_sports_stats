import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/models/Player.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchCubit.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchState.dart';

import '../../AppColors.dart';
import '../../router/routes.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MatchCubit>(
      create: (_) => MatchCubit()..initGame(),
      child: _MatchPage(),
    );
  }
}

class _MatchPage extends StatelessWidget {

  final TextEditingController opponentNameController = TextEditingController();
  final Game game = Game(opponentName: "Charly Bertho", teamPlayers: [
    MatchPlayer(name: "Jamso", number: 1),
    MatchPlayer(name: "Carlito", number: 14),
    MatchPlayer(name: "Jean", number: 5),
    MatchPlayer(name: "Paul", number: 231),
    MatchPlayer(name: "Claude", number: 4),
  ], opponentPlayers: [
    MatchPlayer(name: "Leona", number: 8),
    MatchPlayer(name: "Ezreal", number: 16),
    MatchPlayer(name: "K'Santé", number: 48),
    MatchPlayer(name: "Lux", number: 32),
    MatchPlayer(name: "Kindred", number: 2),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child:
        BlocListener<MatchCubit, MatchState>(listener: (context, state) {
          if( state is BeginMatchState) {
            var newGame = Game(opponentName: state.opponentName,
                atHome: state.atHome,
                teamPlayers: state.selectedPlayers.map((player) => MatchPlayer(name: player.name, number: player.number)).toList(),
                opponentPlayers: game.opponentPlayers);
            context.push(Routes.nestedCurrentMatchPage,
                extra: newGame);
          }
    },child:
        BlocBuilder<MatchCubit, MatchState>(
            builder: (context, state) {
      if (state is MatchStateInProgress) {
        return Container(
            color: AppColors.grey,
            child: Center(
                child: Stack(children: [
              Padding(
                  padding: EdgeInsets.only(top: 75, left: 22),
                  child: Image(
                    image: AssetImage('assets/court_bg.png'),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nouveau match ", style: AppFontStyle.header),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 33,
                            child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: OpponentGameConfiguration(
                                  atHome: state.atHome,
                                  opponentNameController: opponentNameController
                                )),
                          ),
                          StartGameAndParameters(game: game, opponentNameController: opponentNameController),
                          Expanded(
                            flex: 33,
                            child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: RightSideWidget(
                                  teamPlayers: state.teamPlayers
                                )),
                          ),
                        ],
                      ))
                    ],
                  ))
            ])));
      }
      return Container();
    }))));
  }
}

class StartGameAndParameters extends StatelessWidget {
  const StartGameAndParameters({
    super.key,
    required this.game, required this.opponentNameController,
  });

  final Game game;
  final TextEditingController opponentNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: RectangleAnimatedButton(
              onPressed: () {},
              text: "Paramètres du match",
              visible: false,
            )),
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: RectangleAnimatedButton(
              onPressed: () {},
              text: "Statistiques avancées",
              visible: false,
            )),
        Spacer(),
        CircularButton(onPressed: () {
          context.read<MatchCubit>().beginMatch(opponentNameController.text);
        }),
        Spacer(),
        Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: RectangleAnimatedButton(
                onPressed: () {},
                text: "Paramètres du match")),
        Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: RectangleAnimatedButton(
                onPressed: () {},
                text: "Statistiques avancées")),
      ],
    );
  }
}

class RightSideWidget extends StatelessWidget {
  final List<Player> teamPlayers;

  const RightSideWidget({
    super.key,
    required this.teamPlayers,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 5, left: 30, right: 30),
          child: Column(
            children: [
              const Text("Choix de mes joueurs : "),
              Flexible(child:  GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing:10,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                children: teamPlayers.map((player) {
                  return PlayerSelectionWidget(
                      isSelected: player.selected,
                      playerName: player.name,
                      playerNumber: player.number,
                      onPressed: () {
                        if(player.selected) {
                          context.read<MatchCubit>().unselectPlayer(player);
                        } else {
                          context.read<MatchCubit>().selectPlayer(player);
                        }
                      });
                }).toList(),
              ))
            ],
          )),
    );
  }
}

class PlayerSelectionWidget extends StatelessWidget {
  final bool isSelected;
  final String playerName;
  final int playerNumber;
  final VoidCallback onPressed;

  const PlayerSelectionWidget({
    super.key,
    required this.isSelected,
    required this.playerName,
    required this.playerNumber,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color btnColor = isSelected ? AppColors.blue : AppColors.grey;
    Color txtColor = isSelected ? Colors.white : AppColors.blue;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Material(
            color: btnColor,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: AppColors.orange,
                onTap: onPressed, // Utilise la fonction passée en paramètre
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            playerName,
                            style: TextStyle(fontSize: 16, color: txtColor),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(
                                "#$playerNumber",
                                style: const TextStyle(
                                    color: AppColors.blue, fontSize: 18),
                              )))),
                    ],
                  ),
                ))));
  }
}

class OpponentGameConfiguration extends StatelessWidget {

  final bool atHome;
  final TextEditingController opponentNameController;
  const OpponentGameConfiguration({
    super.key, required this.atHome, required this.opponentNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 5, left: 30, right: 30),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                fillColor: AppColors.grey,
                filled: true,
                border: OutlineInputBorder(),
                hintText: "Nom de l'équipe adverse",
              ),
              controller: opponentNameController,
            ),
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: SideSelectionButton(onPressed: () => {context.read<MatchCubit>().updateAtHome()},
                          text: "Domicile",isSelected: atHome,))),
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: SideSelectionButton(
                          onPressed: () => {context.read<MatchCubit>().updateAtHome()},
                          text: "Exterieur", isSelected: !atHome,))),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Center(
                                child: Text(
                              "Joueur adverse ${index + 1} ",
                              style: TextStyle(fontSize: 15),
                            ))),
                        Expanded(
                            flex: 5,
                            child: Center(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all()),
                              height: 30,
                              width: 40,
                            ))),
                      ],
                    ));
              },
            ))
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;

  CircularButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(57.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(57.5),
          splashColor: Colors.deepOrange,
          onTap: onPressed, // Utilise la fonction passée en paramètre
          child: Container(
            width: 115,
            height: 115,
            child: Center(
              child: Text(
                'GO !',
                style: GoogleFonts.anton(
                    textStyle: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ));
  }
}

class RectangleAnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool visible;
  final double width;
  final double height;

  RectangleAnimatedButton(
      {required this.onPressed, required this.text, this.visible = true, this.width = 160, this.height = 45});

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return Container(
        width: width,
        height: height,
        color: Colors.transparent,
      );
    }
    return Material(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.deepOrange,
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.anton(
                    textStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ));
  }
}

class SideSelectionButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onPressed;

  const SideSelectionButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color btnColor = isSelected ? AppColors.blue : AppColors.grey;
    Color txtColor = isSelected ? Colors.white : AppColors.blue;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Material(
            color: btnColor,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: AppColors.orange,
                onTap: onPressed,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 16, color: txtColor),
                          )),
                    ],
                  ),
                ))));
  }
}


