import 'dart:math';
import 'package:flutter/material.dart';

class MyTeddy extends StatelessWidget{
  final int teddySpriteCount;
  final String teddyDirection;

  MyTeddy({required this.teddySpriteCount, required this.teddyDirection});

  @override
  Widget build(BuildContext context)
  {
    if(teddyDirection == 'right'){
      return Container(
        alignment: Alignment.bottomCenter,
        height: 50,
        width: 50,
        child: Image.asset('lib/images/dratinisprite/dratini' +
        teddySpriteCount.toString() +
        '.png'),
      );
    } else{
      return Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.rotationY(pi),
        child: Container(
          height: 50,
          width: 50,
          child: Image.asset('lib/images/dratinisprite/dratini' +
          teddySpriteCount.toString() +
          '.png'),
        ),
      );
    }
  }
}