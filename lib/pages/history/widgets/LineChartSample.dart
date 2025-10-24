import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/models/Game.dart';

class LineChartSample extends StatefulWidget {
  final Game game;

  const LineChartSample({super.key, required this.game});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<Color> gradientColors = [
    AppColors.orange,
    AppColors.yellow,
  ];
  List<Color> opponentGradientColors = [
    AppColors.redBtn,
    AppColors.grey,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('1ER QT', style: style);
        break;
      case 4:
        text = const Text('2EME QT', style: style);
        break;
      case 6:
        text = const Text('3EME QT', style: style);
        break;
      case 8:
        text = const Text('4EME QT', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  LineChartData mainData() {
    var game = widget.game;
    var maxScore = game.quarters
        .map((quarter) => max(quarter.teamScore, quarter.opponentScore))
        .reduce(max);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.blue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.redBtn,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: maxScore.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 0),
            FlSpot(2, game.getQuarterTeamScore(1).toDouble()),
            FlSpot(4, game.getQuarterTeamScore(2).toDouble()),
            FlSpot(6, game.getQuarterTeamScore(3).toDouble()),
            FlSpot(8, game.getQuarterTeamScore(4).toDouble()),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: [
            const FlSpot(0, 0),
            FlSpot(2, game.getQuarterOpponentScore(1).toDouble()),
            FlSpot(4, game.getQuarterOpponentScore(2).toDouble()),
            FlSpot(6, game.getQuarterOpponentScore(3).toDouble()),
            FlSpot(8, game.getQuarterOpponentScore(4).toDouble()),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: opponentGradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: opponentGradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
