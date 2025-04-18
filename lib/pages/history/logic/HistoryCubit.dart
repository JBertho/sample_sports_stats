import 'package:bloc/bloc.dart';

import 'HistoryState.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(): super(InitHistoryState());

  void initHistory(game) {
    emit(DisplayHistoryState(game));
  }
}
