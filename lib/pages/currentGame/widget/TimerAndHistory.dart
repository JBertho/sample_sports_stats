import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/models/History.dart';
import 'package:sample_sport_stats/pages/currentGame/extension/DurationExtension.dart';

import '../logic/CurrentGameCubit.dart';
import '../logic/CurrentGameState.dart';
import '../model/ChronometerModel.dart';

class TimerAndHistory extends StatelessWidget {
  const TimerAndHistory({super.key, required this.state});

  final CurrentGameInProgress state;

  Widget buildHistoryString(History history) {
    if (history.actionGame.type == ActionType.failedShot ||
        history.actionGame.type == ActionType.turnover ||
        history.actionGame.type == ActionType.fault) {
      return RichText(
          text: TextSpan(
              style: AppFontStyle.anton.copyWith(color: Colors.black),
              children: [
            TextSpan(
                text: history.actionGame.name,
                style: const TextStyle(color: Colors.red)),
            const TextSpan(text: " de "),
            TextSpan(
                text: history.player.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]));
    }
    if (history.actionGame.type == ActionType.point ||
        history.actionGame.type == ActionType.rebound ||
        history.actionGame.type == ActionType.counter) {
      return RichText(
          text: TextSpan(
              style: AppFontStyle.anton.copyWith(color: Colors.black),
              children: [
            TextSpan(
                text: history.actionGame.name,
                style: const TextStyle(color: Colors.green)),
            const TextSpan(text: " de "),
            TextSpan(
                text: history.player.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]));
    }
    return Text("NOT_DEFINED");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white85,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<ChronometerModel>(
              builder: (context, chronometerModel, child) {
            return Chronometer(
              periodNumber: chronometerModel.quarter,
              chronometerModel: chronometerModel,
            );
          }),
          Expanded(
            child: ListView.separated(
              itemCount: state.histories.length,
              itemBuilder: (context, index) {
                var history = state.histories.reversed.toList()[index];
                return ListTile(
                  title: Text(
                      history.elapsedTime.formatToHoursMinutesAndSeconds()),
                  subtitle: buildHistoryString(history),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.greyComplement,
                    ),
                    onPressed: () {
                      context.read<CurrentGameCubit>().deleteHistory(history);
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  indent: 20,
                  endIndent: 20,
                  color: AppColors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Chronometer extends StatefulWidget {
  final int periodNumber;
  final ChronometerModel chronometerModel;

  const Chronometer(
      {super.key, required this.periodNumber, required this.chronometerModel});

  @override
  State<StatefulWidget> createState() {
    return _ChronometerState();
  }
}

class _ChronometerState extends State<Chronometer> {
  static const quarterDuration = Duration(seconds: 20);

  void _startStopwatch() {
    widget.chronometerModel.startStopwatch();
  }
  void _nextQuarter(BuildContext context) {
    context.read<CurrentGameCubit>().saveQuarter(widget.chronometerModel.quarter, widget.chronometerModel.elapsedTime);
    widget.chronometerModel.nextQuarter();
  }

  String _formatElapsedTime(Duration time) {
    return time.formatToHoursMinutesAndSeconds();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var values = _formatElapsedTime(widget.chronometerModel.elapsedTime);
    return Column(
      children: [
        Text(
          values,
          style: const TextStyle(fontSize: 32.0),
        ),
        const SizedBox(height: 2.0),
        Text(
          "Période ${widget.periodNumber}",
          style: AppFontStyle.smallComplement,
        ),

        const SizedBox(height: 20.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(57.5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(57.5),
                  splashColor: Colors.deepOrange,
                  onTap: _startStopwatch,
                  child: Container(
                    width: 69,
                    height: 69,
                    child: Center(
                      child: Icon(
                        widget.chronometerModel.isRunning()
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
            if (widget.chronometerModel.elapsedTime > quarterDuration)
              const SizedBox(width: 50),
            if (widget.chronometerModel.elapsedTime > quarterDuration)
              Material(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(57.5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(57.5),
                    splashColor: Colors.deepOrange,
                    onTap: () => _nextQuarter(context),
                    child: Container(
                      width: 69,
                      height: 69,
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ))
          ],
        )
        // Start/Stop and Reset buttons
      ],
    );
  }
}
