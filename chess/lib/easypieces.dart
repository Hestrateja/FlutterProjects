import 'package:flutter/material.dart';

class EasyPieces extends StatelessWidget
{
  final String piece;
  final String color;


  EasyPieces({this.color, this.piece});

  Widget build(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(10),
      child: Image.asset("lib/images/"+piece+color+".png"),
    );
  }
}