import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/Team.dart';
import 'package:sample_sport_stats/pages/TeamsSelection/logic/TeamsSelectionCubit.dart';
import 'package:sample_sport_stats/pages/TeamsSelection/logic/TeamsSelectionState.dart';

import '../../AppColors.dart';
import '../../router/routes.dart';
import '../currentGame/widget/FinishGameDialog.dart';

class TeamsSelectionPage extends StatelessWidget {
  const TeamsSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TeamsSelectionPage();
  }
}

class _TeamsSelectionPage extends StatelessWidget {
  _TeamsSelectionPage();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.grey,
        body: SafeArea(
            child: BlocListener<TeamSelectionCubit, TeamsSelectionState>(
                listener: (context, state) {
                  if (state is TeamSelectionCreation) {
                    showDialog(
                      context: context,
                      builder: (BuildContext _) {
                        return CreationDialog(
                          nameController: nameController,
                          divisionController: divisionController,
                          seasonController: seasonController,
                          callback: () {
                            context.read<TeamSelectionCubit>().createTeam(Team(
                                name: nameController.text,
                                division: divisionController.text,
                                season: seasonController.text));
                          },
                        );
                      },
                    );
                  }
                },
                child: const Row(
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
                ))));
  }
}

class RightSideTeamMenu extends StatelessWidget {
  const RightSideTeamMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamSelectionCubit, TeamsSelectionState>(
        builder: (context, state) {
      List<Team> teams = state.teams;
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
            children: [
              ...teams.map((team) => TeamSelectionWidget(team: team)),
              if (teams.length < 4) const NewTeamSelectionWidget()
            ],
          )),
        ],
      ));
    });
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
  final Team team;

  const TeamSelectionWidget({super.key, required this.team});

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
                  context.read<TeamSelectionCubit>().selectTeam(team);
                  context.push(Routes.matchPage, extra: team);
                },
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
                            Text(team.name, style: AppFontStyle.teamHeader),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Icon(Icons.star),
                                const SizedBox(width: 15),
                                Text(
                                  team.season,
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
                                  team.division,
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
                context.read<TeamSelectionCubit>().creationTeamPressed();
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

class CreationDialog extends StatelessWidget {
  final Function callback;
  final TextEditingController nameController;
  final TextEditingController divisionController;
  final TextEditingController seasonController;

  const CreationDialog(
      {super.key,
      required this.callback,
      required this.nameController,
      required this.divisionController,
      required this.seasonController});

  @override
  Widget build(BuildContext context) {
    Widget okButton = DialogBtn(
        callback: () {
          callback();
          Navigator.of(context).pop();
        },
        displayValue: "Valider");
    Widget cancelButton = DialogBtn(
      callback: () {
        Navigator.of(context).pop();
      },
      displayValue: "Annuler",
      color: Colors.red,
      splashColor: Colors.redAccent,
    );

    return AlertDialog(
      title: Text("Création d'équipe", style: AppFontStyle.anton),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
                fillColor: AppColors.grey,
                filled: true,
                border: const OutlineInputBorder(),
                hintText: "Nom de l'équipe",
                helperStyle: AppFontStyle.anton),
            controller: nameController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: InputDecoration(
                fillColor: AppColors.grey,
                filled: true,
                border: const OutlineInputBorder(),
                hintText: "Division",
                helperStyle: AppFontStyle.anton),
            controller: divisionController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: InputDecoration(
                fillColor: AppColors.grey,
                filled: true,
                border: const OutlineInputBorder(),
                hintText: "Saison",
                helperStyle: AppFontStyle.anton),
            controller: seasonController,
          ),
        ],
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );
  }
}
