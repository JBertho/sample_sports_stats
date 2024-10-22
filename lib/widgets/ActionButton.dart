import 'package:flutter/material.dart';

class Actionbutton extends StatelessWidget {
  final String text;
  final Function callback;
  final Color color;

  const Actionbutton({
    Key? key,
    this.color = Colors.blue, required this.text, required this.callback,
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
        callback();

      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$text',
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