import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final String playerName;
  final int playerNumber;
  final Color color;

  const PlayerButton({
    Key? key,
    required this.playerName,
    required this.playerNumber, this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joueur : $playerName, Numéro : $playerNumber')));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$playerName #$playerNumber',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}