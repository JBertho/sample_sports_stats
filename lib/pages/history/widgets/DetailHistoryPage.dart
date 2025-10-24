import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/pages/history/widgets/LineChartSample.dart';

import '../../../AppFontStyle.dart';
import '../logic/HistoryState.dart';

class DetailHistoryPage extends StatelessWidget {
  final DisplayHistoryState state;
  final double TEAM_SCORE_SPACING = 20;

  const DetailHistoryPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(right: TEAM_SCORE_SPACING),
                              child: Text(state.game.team.name,
                                  style: AppFontStyle.header)))),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: 120,
                        child: Center(
                            child: IntrinsicHeight(
                                child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${state.game.teamScore}",
                              style: AppFontStyle.scoreHeader.copyWith(
                                  color: state.game.teamScore >
                                          state.game.opponentScore
                                      ? AppColors.yellow
                                      : AppColors.blue),
                            ),
                            const VerticalDivider(
                              width: 20,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: Colors.black,
                            ),
                            Text(
                              "${state.game.opponentScore}",
                              style: AppFontStyle.scoreHeader.copyWith(
                                  color: state.game.opponentScore >
                                          state.game.teamScore
                                      ? AppColors.yellow
                                      : AppColors.blue),
                            )
                          ],
                        )))),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: TEAM_SCORE_SPACING),
                              child: Text(state.game.opponentName,
                                  style: AppFontStyle.header))))
                ]),
                const SizedBox(height: 25),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text("Par quart-temps"),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.white85,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                                child: Text('Equipe',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic))),
                          ),
                          DataColumn(label: Spacer()),
                          DataColumn(
                            label: Expanded(
                                child: Text('1',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Text('2',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Text('3',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Text('4',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic))),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(state.game.team.name)),
                              const DataCell(Spacer()),
                              DataCell(Text(state.game
                                  .getQuarterTeamScore(1)
                                  .toString())),
                              DataCell(Text(state.game
                                  .getQuarterTeamScore(2)
                                  .toString())),
                              DataCell(Text(state.game
                                  .getQuarterTeamScore(3)
                                  .toString())),
                              DataCell(Text(state.game
                                  .getQuarterTeamScore(4)
                                  .toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(state.game.opponentName)),
                              const DataCell(Spacer()),
                              DataCell(Text(state.game
                                  .getQuarterOpponentScore(1)
                                  .toString())),
                              DataCell(Text(state.game
                                  .getQuarterOpponentScore(2)
                                  .toString())),
                              DataCell(Text(state.game
                                  .getQuarterOpponentScore(3)
                                  .toString())),
                              DataCell(Text(state.game
                                  .getQuarterOpponentScore(4)
                                  .toString())),
                            ],
                          )
                        ],
                      )),
                ),
                const SizedBox(height: 25),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.white85,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: LineChartSample(
                        game: state.game,
                      ),
                    ))
              ],
            )));
  }
}
