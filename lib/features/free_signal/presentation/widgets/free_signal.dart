import 'package:flutter/material.dart';

class FreeSignal extends StatelessWidget {
  const FreeSignal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.abc,
            color: Color.fromARGB(255, 47, 31, 31),
          ),
          SizedBox(width: 10),
          Text(
            "signal.title",
            style: TextStyle(
              color: Color.fromARGB(255, 62, 38, 38),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
