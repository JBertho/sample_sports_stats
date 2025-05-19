import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../../models/Game.dart';
import 'HistoryState.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(InitHistoryState());

  void initHistory(Game game) {
    log("Quarters : " + game.quarters.toString());
    emit(DisplayHistoryState(game));
  }
}
