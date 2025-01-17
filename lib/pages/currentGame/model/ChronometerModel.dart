import 'dart:async';
import 'package:flutter/material.dart';

class ChronometerModel with ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  Duration _elapsedTime = Duration.zero;
  late Timer _timer;

  Duration get elapsedTime => _elapsedTime;

  ChronometerModel() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (_stopwatch.isRunning) {
        _elapsedTime = _stopwatch.elapsed;
        notifyListeners(); // Notify listeners when the time is updated
      }
    });
  }

  void startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      notifyListeners();
    } else {
      _stopwatch.stop();
      notifyListeners();
    }
  }

  void resetStopwatch() {
    _stopwatch.reset();
    _elapsedTime = Duration.zero;
    notifyListeners();
  }

  bool isRunning() {
    return _stopwatch.isRunning;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}