import 'package:flutter/cupertino.dart';

import '../logic/HistoryState.dart';

class StatsHistoryPage extends StatelessWidget {
  final DisplayHistoryState state;

  const StatsHistoryPage({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Text("Les Stats");
  }
}