import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_sport_stats/models/Opponent.dart';

class CurrentMatchpage extends StatefulWidget {
  final Opponent opponent;

  const CurrentMatchpage({super.key, required this.opponent});

  @override
  State<StatefulWidget> createState() {
    return CurrentMatchpageState();
  }
}

class CurrentMatchpageState extends State<CurrentMatchpage> {
  List<String> players = [
    "Joueur 1",
    "Joueur 2",
    "Joueur 3",
    "Joueur 4",
    "Joueur 5"
  ];
  List<String> enemies = [
    "Adversaire 1",
    "Adversaire 2",
    "Adversaire 3",
    "Adversaire 4",
    "Adversaire 5"
  ];

  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var name = widget.opponent.name;
    var rank = widget.opponent.rank;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match en cours"),
      ),
      body: Column(children: [
        Text("Face à :  $name $rank"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ElevatedButton(
                  onPressed: () {
                    showOverlay(context);
                  },
                  child: Text(players[0]),
                ),
                  ElevatedButton(
                    onPressed: () {
                      showOverlay(context);
                    },
                    child: Text(players[1]),
                  )]),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ElevatedButton(
                  onPressed: () {
                    showOverlay(context);
                  },
                  child: Text(players[2]),
                ),
                  ElevatedButton(
                    onPressed: () {
                      showOverlay(context);
                    },
                    child: Text(players[3]),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showOverlay(context);
                    },
                    child: Text(players[4]),
                  )]),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ElevatedButton(
                  onPressed: () {
                    showOverlay(context);
                  },
                  child: Text(enemies[0]),
                ),
                  ElevatedButton(
                    onPressed: () {
                      showOverlay(context);
                    },
                    child: Text(enemies[1]),

                  ),ElevatedButton(
                    onPressed: () {
                      showOverlay(context);
                    },
                    child: Text(enemies[2]),
                  )]),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ElevatedButton(
                  onPressed: () {
                    showOverlay(context);
                  },
                  child: Text(enemies[3]),
                ),
                  ElevatedButton(
                    onPressed: () {
                      showOverlay(context);
                    },
                    child: Text(enemies[4]),
                  ),
                ]),
          ],
        )
      ]),
    );
  }

  void showOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: MediaQuery.of(context).size.width / 8,
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.84,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Bouton 1")),
                    ElevatedButton(onPressed: () {}, child: Text("Bouton 2")),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Bouton 3")),
                    ElevatedButton(onPressed: () {}, child: Text("Bouton 4")),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    overlayEntry?.remove();

                  },
                  child: Text("Fermer"),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }
}
