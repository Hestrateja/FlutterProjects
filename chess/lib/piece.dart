import 'package:flutter/material.dart';


class MyPiece extends StatelessWidget
{
  final String piece;
  final String killMove;
  final String color;
  final String thisPieceIsSelected;
  final ontap;

  MyPiece({this.piece, this.color, this.ontap, this.thisPieceIsSelected,this.killMove});

  @override
  Widget build(BuildContext context)
  {
    if(killMove == "k")
    {
      return GestureDetector(
        onTap: ontap,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.all(5),
            child: Image.asset("lib/images/"+piece+color+".png"),
          ),
        ),
      );
    }
    else if(piece == "o")
    {
      return GestureDetector(
        onTap: ontap,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.green[200],
          ),
        ),
      );
    }

    else if(piece != "x")
    {
      return GestureDetector(
        onTap: ontap,
        child: Container(
          color: thisPieceIsSelected == "selected"?Colors.green: Colors.transparent,
          padding: const EdgeInsets.all(10.0),
          child: Image.asset("lib/images/"+piece+color+".png"),
        ),
      );
    }

    return Container();
  }
}