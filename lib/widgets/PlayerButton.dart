import 'package:flutter/material.dart';

import '../AppFontStyle.dart';

class PlayerButton extends StatelessWidget {
  final String playerName;
  final int playerNumber;
  final Color color;
  final Color splashColor;
  final Function callback;
  final double fontSize;
  final int faultNumber;

  const PlayerButton({
    super.key,
    required this.playerName,
    required this.playerNumber,
    this.color = Colors.blue,
    required this.callback,
    required this.splashColor,
    this.fontSize = 14,
    required this.faultNumber
  });

  @override
  Widget build(BuildContext context) {
    List<bool> faults = [false, false, false, false, false];
    for (int i = 0; i < faultNumber; i++) {
      faults[i] = true;
    }

    return Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: splashColor,
          onTap: () => callback(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                  width: 150,
                  height: 45,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        child: Center(
                          child: Text("$playerNumber",
                              textAlign: TextAlign.center,
                              style: AppFontStyle.anton
                                  .copyWith(color: color, fontSize: fontSize)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(playerName,
                                  style: AppFontStyle.anton.copyWith(
                                      color: Colors.white,
                                      fontSize: fontSize))),
                          const SizedBox(height: 3),
                          Row(
                              children: faults.map((hasFault) {
                            if (hasFault) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey)));
                            }
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white)));
                          }).toList())
                        ],
                      ))
                    ],
                  ))),
        ));
  }
}
