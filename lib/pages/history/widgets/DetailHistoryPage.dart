import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/pages/history/widgets/LineChartSample2.dart';

import '../../../AppFontStyle.dart';
import '../logic/HistoryState.dart';

class DetailHistoryPage extends StatelessWidget {
  final DisplayHistoryState state;
  final double TEAM_SCORE_SPACING = 20;

  const DetailHistoryPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: EdgeInsets.only(right: TEAM_SCORE_SPACING),
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
                          padding: EdgeInsets.only(left: TEAM_SCORE_SPACING),
                          child: Text(state.game.opponentName,
                              style: AppFontStyle.header))))
            ]),
            SizedBox(height: 25),
            Align(
              child: Text("Par quart-temps"),
              alignment: AlignmentDirectional.centerStart,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.white85,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                            child: Text('Equipe',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                      DataColumn(label: Spacer()),
                      DataColumn(
                        label: Expanded(
                            child: Text('1',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                      DataColumn(
                        label: Expanded(
                            child: Text('2',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                      DataColumn(
                        label: Expanded(
                            child: Text('3',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                      DataColumn(
                        label: Expanded(
                            child: Text('4',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(state.game.team.name)),
                          DataCell(Spacer()),
                          DataCell(Text('22')),
                          DataCell(Text('12')),
                          DataCell(Text('28')),
                          DataCell(Text('16')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(state.game.opponentName)),
                          DataCell(Spacer()),
                          DataCell(Text('18')),
                          DataCell(Text('21')),
                          DataCell(Text('21')),
                          DataCell(Text('13')),
                        ],
                      )
                    ],
                  )),
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.white85,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: LineChartSample2(),
            ))
          ],
        )));
  }
}
