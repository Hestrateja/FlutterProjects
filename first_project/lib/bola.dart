import 'package:flutter/material.dart';

class MyBall extends StatelessWidget{
  final double ballX;
  final double ballY;
  final diameter;
  //He puesto para que se pueda cambiar el ancho y alto de la bola en el constructor
  MyBall({required this.ballX, required this.ballY,required this.diameter});
  @override
  Widget build(BuildContext context)
  {
    return Container(
      alignment: Alignment(ballX,ballY),
      child: Container(
        height: this.diameter,
        width: this.diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.brown,
        )
      ),
    );
  }
}