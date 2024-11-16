import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      Text("Nouveau match ",
                          style: GoogleFonts.anton(
                              textStyle: const TextStyle(
                                  fontSize: 40, color: AppColors.blue))),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 33,
                            child: Padding(
                                padding: EdgeInsets.all(25),
                                child: LeftSideWidget()),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: RectangleRoundedButton(
                                    onPressed: () {},
                                    text: "Paramètres du match",
                                    visible: false,
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: RectangleRoundedButton(
                                    onPressed: () {},
                                    text: "Statistiques avancées",
                                    visible: false,
                                  )),
                              Spacer(),
                              CircularButton(onPressed: () {
                                context.push(Routes.nestedCurrentMatchPage,
                                    extra: game);
                              }),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: RectangleRoundedButton(
                                      onPressed: () {},
                                      text: "Paramètres du match")),
                              Padding(
                                  padding: EdgeInsets.only(bottom: 30),
                                  child: RectangleRoundedButton(
                                      onPressed: () {},
                                      text: "Statistiques avancées")),
                            ],
                          ),
                          Expanded(
                            flex: 33,
                            child: Padding(
                                padding: EdgeInsets.all(25),
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
    })));
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
    int middleIndex = (teamPlayers.length / 2).round();

    List<Player> group1 = teamPlayers.sublist(0, middleIndex);
    List<Player> group2 = teamPlayers.sublist(middleIndex);
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
              Row(
                children: [
                  Expanded(
                      child: Column(
                          children: group1.map((player) {
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
                  }).toList())),
                  Expanded(
                      child: Column(
                          children: group2.map((player) {
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
                  }).toList())),
                ],
              )
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

class LeftSideWidget extends StatelessWidget {
  const LeftSideWidget({
    super.key,
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
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.grey,
              ),
              child: const Text("Nom de l'équipe adverse"),
            ),
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.blue),
                            child: Center(
                              child: Text("Domicile",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            height: 60))),
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey),
                            child: Center(
                              child: Text("Exterieur",
                                  style: TextStyle(color: AppColors.blue)),
                            ),
                            height: 60))),
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

class RectangleRoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool visible;

  RectangleRoundedButton(
      {required this.onPressed, required this.text, this.visible = true});

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return Container(
        width: 160,
        height: 45,
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
            width: 160,
            height: 45,
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
