import 'dart:math';

import 'package:flutter/material.dart';

class BlueSnail extends StatelessWidget{
  final int snailSpriteCount;
  final String snailDirection;
  final int deadSnailSprite;
  int directionInt = 0;

  BlueSnail({required this.snailSpriteCount, required this.snailDirection, required this. deadSnailSprite});

  @override
  Widget build(BuildContext context){
    if(snailDirection == 'left'){
      directionInt = 0;
    }else{
      directionInt = 1;
    }

    if(deadSnailSprite == 0){
      return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi*directionInt),
          child: Container(
            alignment: Alignment(0,1),
            height: 100,
            width: 100,
            child: Image.asset(
              'lib/images/ducksprite/duck'+
              (snailSpriteCount % 10 +1).toString() +
              '.png',
            ),
          ),
        );
    }else{
      return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi*directionInt),
          child: Container(
            alignment: Alignment(0,1),
            height: 100,
            width: 100,
            child: Image.asset(
              'lib/images/explosionsprite/explosion'+
              (deadSnailSprite).toString() +
              '.png',
            ),
          ),
        );
    }
  }
}