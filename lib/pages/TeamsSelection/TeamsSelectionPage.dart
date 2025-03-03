import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';

import '../../AppColors.dart';
import '../../router/routes.dart';

class TeamsSelectionPage extends StatelessWidget {
  const TeamsSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: AppColors.grey,
        body: SafeArea(
            child: Row(
          children: [
            Expanded(
              flex: 45,
              child: LeftSideTeamMenu(),
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
    List<String?> teams = ["Bulls", "Cavaliers", "Warriors", null];

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  size: 42,
                )),
            const SizedBox(width: 10)
          ],
        ),
        const SizedBox(
          height: 105,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Mes équipes",
              style: AppFontStyle.header,
            ),
          ),
        ),
        Flexible(
            child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          childAspectRatio: 300 / 140,
          children: teams.map((team) {
            if (team != null) {
              return TeamSelectionWidget(teamName: team);
            }
            return const NewTeamSelectionWidget();
          }).toList(),
        )),
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
    return Stack(children: [
      const SizedBox.expand(
          child: Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/team_bg.jpg'),
      )),
      Padding(
          padding: const EdgeInsets.only(top: 40, left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.ac_unit, size: 66)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Track'Up",
                    style: AppFontStyle.anton.copyWith(fontSize: 46),
                  ),
                  Text(
                    "Analyse tes matchs, améliore ton jeu",
                    style: AppFontStyle.anton.copyWith(fontSize: 12),
                  ),
                ],
              )
            ],
          ))
    ]);
  }
}

class TeamSelectionWidget extends StatelessWidget {
  final String teamName;

  const TeamSelectionWidget({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    Color btnColor = AppColors.white85;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Material(
            color: btnColor,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: AppColors.orange,
                onTap: () {
                  context.push(Routes.matchPage);
                }, // Utilise la fonction passée en paramètre
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(teamName, style: AppFontStyle.teamHeader),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Icon(Icons.star),
                                const SizedBox(width: 15),
                                Text(
                                  "Régional Div 3",
                                  style: AppFontStyle.anton,
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined),
                                const SizedBox(width: 15),
                                Text(
                                  "2024-2025",
                                  style: AppFontStyle.anton,
                                )
                              ],
                            )
                          ],
                        )),
                  ]),
                ))));
  }
}

class NewTeamSelectionWidget extends StatelessWidget {
  const NewTeamSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color btnColor = AppColors.orangeBackground;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Material(
            color: btnColor,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: AppColors.orange,
              onTap: () {
                context.push(Routes.matchPage);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.orange, width: 3)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: AppColors.orange,
                      size: 54,
                    ),
                    Text("Ajouter une équipe",
                        style:
                            TextStyle(color: AppColors.fontGrey, fontSize: 20)),
                  ],
                ),
              ),
            )));
  }
}
