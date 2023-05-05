import 'package:flutter/material.dart';


class ScoreBoard extends StatelessWidget
{
  final int player1Score;
  final int player2Score;
  final bool gameHasStarted;


  ScoreBoard({required this.gameHasStarted, required this.player1Score, required this.player2Score});

  @override
  Widget build(BuildContext context)
  {
    return gameHasStarted? 
      Stack(
        children: [
          Container(
            alignment: Alignment(0,-0.3),
            child: Text(player2Score.toString(), style: TextStyle(color: Colors.grey[800], fontSize: 100)),
          ),

          Container(
            alignment: Alignment(0,0),
            child: Container(
              width: MediaQuery.of(context).size.width/4,
              height: 1,
              color: Colors.grey[800],
            ),
          ),

          Container(
            alignment: Alignment(0,0.3),
            child: Text(player1Score.toString(), style: TextStyle(color: Colors.grey[800], fontSize: 100)),
          )


        ],
      )
      :Container();
  }
}