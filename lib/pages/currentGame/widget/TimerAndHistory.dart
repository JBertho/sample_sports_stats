import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';

import '../logic/CurrentGameState.dart';
import '../model/ChronometerModel.dart';


class TimerAndHistory extends StatelessWidget {
  const TimerAndHistory({
    super.key,
    required this.state, required this.chronometerModel,
  });

  final CurrentGameInProgress state;
  final ChronometerModel chronometerModel;

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
          Chronometer(periodNumber: 1, chronometerModel: chronometerModel),
          Expanded(
            child: ListView.builder(
              itemCount: state.histories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${state.histories[index].player.name} => ${state.histories[index].actionGame.name}'),
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

  const Chronometer({super.key, required this.periodNumber, required this.chronometerModel});

  @override
  State<StatefulWidget> createState() {
    return _ChronometerState();
  }
}

class _ChronometerState extends State<Chronometer> {
  late String _elapsedTimeString;

  @override
  void initState() {
    super.initState();

    _elapsedTimeString = _formatElapsedTime(widget.chronometerModel.elapsedTime);
  }

  void _startStopwatch() {
    widget.chronometerModel.startStopwatch();
  }

  void _resetStopwatch() {
    widget.chronometerModel.resetStopwatch();

    _updateElapsedTime();
  }

  void _updateElapsedTime() {
    setState(() {
      _elapsedTimeString = _formatElapsedTime(widget.chronometerModel.elapsedTime);
    });
  }

  String _formatElapsedTime(Duration time) {
    return '${time.inHours.remainder(24).toString().padLeft(2, '0')} : ${time.inMinutes.remainder(60).toString().padLeft(2, '0')} : ${(time.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _elapsedTimeString,
          style: const TextStyle(fontSize: 32.0),
        ),
        const SizedBox(height: 2.0),
        Text("Période ${widget.periodNumber}", style: AppFontStyle.smallComplement,),

        const SizedBox(height: 20.0),
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
                  child: Icon(false ?  Icons.pause : Icons.play_arrow, size: 40, color: Colors.white,),
                ),
              ),
            ))
        // Start/Stop and Reset buttons
      ],
    );
  }
}
