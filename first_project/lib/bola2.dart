import 'package:flutter/material.dart';

class MyBall2 extends StatelessWidget{
  final double ballX;
  final double ballY;

  MyBall2({required this.ballX,required this.ballY});
  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment(ballX,ballY),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        )
      ),
    );
  }
}