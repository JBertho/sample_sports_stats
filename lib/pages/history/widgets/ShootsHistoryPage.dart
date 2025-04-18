import 'package:flutter/cupertino.dart';

import '../logic/HistoryState.dart';

class ShootsHistoryPage extends StatelessWidget {
  final DisplayHistoryState state;

  const ShootsHistoryPage({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Text("Les tirs");
  }
}