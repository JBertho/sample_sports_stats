import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';

import '../../AppColors.dart';
import '../../router/routes.dart';

class TeamsSelectionPage extends StatelessWidget {
  const TeamsSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Row(
      children: [
        Expanded(
          child: LeftSideTeamMenu(),
          flex: 45,
        ),
        Flexible(
          flex: 55,
          child: RightSideTeamMenu(),
        )
      ],
    )));
  }
}

class RightSideTeamMenu extends StatelessWidget {
  const RightSideTeamMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    List<String?> teams =  ["Bulls", "Cavaliers", "Warriors", null];

    return Center(
        child: Column(
      children: [
        Row(),
        Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Align(
            alignment: Alignment.centerLeft,
            child:  Text(
            "Mes équipes",
            style: AppFontStyle.header,
          ),),
        ),
        Flexible(child:
        GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: teams.map((team) {
            if(team != null) {
              return TeamSelectionWidget(teamName: team);
            }
            return const TeamSelectionWidget(teamName: "VIDE");
          }).toList(),
        ))
      ],
    ));
  }
}

class LeftSideTeamMenu extends StatelessWidget {
  const LeftSideTeamMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      SizedBox.expand(
          child: Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/team_bg.jpg'),
      )),
      Text("Track'Up")
    ]);
  }
}

class TeamSelectionWidget extends StatelessWidget {
  final String teamName;

  const TeamSelectionWidget({required this.teamName});



  @override
  Widget build(BuildContext context) {
    Color btnColor =  AppColors.grey;
    Color txtColor =  AppColors.blue;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Material(
            color: btnColor,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: AppColors.orange,
                onTap: () {context.push(Routes.matchPage);}, // Utilise la fonction passée en paramètre
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
                            teamName,
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
                                    "#$teamName",
                                    style: const TextStyle(
                                        color: AppColors.blue, fontSize: 18),
                                  )))),
                    ],
                  ),
                ))));
  }
}
