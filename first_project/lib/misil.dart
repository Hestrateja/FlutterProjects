import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget{
  final missileX;
  final altura;

  MyMissile({this.missileX,this.altura});
  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment(missileX,1),
      child: Container(
        width: 2,
        height: altura,
        color: Colors.red,
      ),
    );
  }
}