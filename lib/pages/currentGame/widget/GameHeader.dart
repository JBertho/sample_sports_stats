import 'package:flutter/material.dart';

import '../../../AppFontStyle.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({
    super.key,
    required this.opponentName,
    required this.atHomeValue,
    required this.teamName,
    required this.teamScore,
    required this.opponentScore,
  });

  static const double TEAM_SCORE_SPACING = 20;

  final String opponentName;
  final String teamName;
  final String atHomeValue;
  final int teamScore;
  final int opponentScore;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: TEAM_SCORE_SPACING),
                    child: Text(teamName, style: AppFontStyle.header)))),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 120,
              child: Center(
                  child: IntrinsicHeight(
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$teamScore",
                    style: AppFontStyle.scoreHeader,
                  ),
                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.black,
                  ),
                  Text(
                    "$opponentScore",
                    style: AppFontStyle.scoreHeader,
                  )
                ],
              )))),
        ),
        Expanded(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: TEAM_SCORE_SPACING),
                    child: Text(opponentName, style: AppFontStyle.header))))
      ]),
      Text(
        atHomeValue,
        style: AppFontStyle.smallComplement,
      )
    ]);
  }
}
