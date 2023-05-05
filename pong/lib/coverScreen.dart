import 'package:flutter/material.dart';


class CoverScreen extends StatelessWidget
{
  final bool gameHasStarted;

  CoverScreen({required this.gameHasStarted});

  @override
  Widget build(BuildContext context)
  {
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
          alignment: Alignment(0,-0.2),
          child: Text(
            gameHasStarted?"":"TAP TO PLAY",
            style: TextStyle(color: Colors.white,fontSize: 20),
          ),
        )
      ],
    );
  }
}