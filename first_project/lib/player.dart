import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget{
  final playerX;
  MyPlayer({this.playerX});

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment(playerX,1),
      child: Container(
        color: Colors.blue,
        width: 50,
        height: 50,
      ),
    );
  }

}