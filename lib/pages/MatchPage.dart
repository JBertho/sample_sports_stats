import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/Player.dart';

import '../AppColors.dart';
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
        body: SafeArea(child: Container(
            color: AppColors.grey,
            child:Center(
        child: Padding(padding: EdgeInsets.only(top: 40), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nouveau match ", style: GoogleFonts.anton(textStyle: const TextStyle(fontSize: 40, color: AppColors.blue))),
        Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 33,
              child: Padding(padding: const EdgeInsets.all(25),child:  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(padding: const EdgeInsets.all(10),
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
                        Expanded(flex: 5,  child: Padding(padding: EdgeInsets.only(top: 10,right: 10),child:Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.blue
                          ),
                          child: Center(child:Text("Domicile", style: TextStyle(color: Colors.white)),),
                          height: 60))),
                        Expanded(flex: 5,  child: Padding(padding: const EdgeInsets.only(top: 10,left: 10),child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey
                            ),
                            child: Center(child:Text("Exterieur", style: TextStyle(color: AppColors.blue)),),
                            height: 60))),
                      ],
                    ),
                    Expanded(child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Row(
                          children: [
                            Expanded(flex: 5, child: Center(child:Text("Joueur adverse ${index + 1} ", style: TextStyle( fontSize: 15),))),
                            Expanded(flex: 5, child: Center(child:Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()
                              ),
                              height: 30,
                              width: 40,
                            ))),
                          ],
                        ));
                      },

                    ))

                  ],
                ),),
              )),
              
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 30), child:RectangleRoundedButton(onPressed: (){}, text: "Paramètres du match", visible: false,)),
                Padding(padding: EdgeInsets.only(top: 20), child:RectangleRoundedButton(onPressed: (){}, text: "Statistiques avancées", visible: false,)),
                Spacer(),
                CircularButton(onPressed: () {
                  context.push(Routes.nestedCurrentMatchPage,
                      extra: game);
                }),
                Spacer(),
                Padding(padding: EdgeInsets.only(bottom: 20), child: RectangleRoundedButton(onPressed: (){}, text: "Paramètres du match")),
                Padding(padding: EdgeInsets.only(bottom: 30), child: RectangleRoundedButton(onPressed: (){}, text: "Statistiques avancées")),
              ],
            ),
            Expanded(
              flex: 33,
              child: Padding(padding: EdgeInsets.all(25),child:  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,

                ),
              )),

            ),
          ],
        ))
      ],
    ))))));
  }
}


class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;

  CircularButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Material(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(57.5),
        child:InkWell(
      borderRadius: BorderRadius.circular(57.5),
      splashColor: Colors.deepOrange,
      onTap: onPressed, // Utilise la fonction passée en paramètre
      child: Container(
        width: 115,
        height: 115,
        child: Center(
          child: Text(
            'GO !',
            style: GoogleFonts.anton(textStyle: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
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

  RectangleRoundedButton({required this.onPressed, required this.text, this.visible = true});

  @override
  Widget build(BuildContext context) {
    if( !visible ) {
      return Container(
          width: 160,
          height: 45,
        color: Colors.transparent,
      );
    }
    return  Material(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(10),
        child:InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.deepOrange,
          onTap: onPressed, // Utilise la fonction passée en paramètre
          child: Container(
            width: 160,
            height: 45,
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.anton(textStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ));
  }
}