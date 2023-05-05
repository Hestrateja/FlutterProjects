import 'package:flutter/material.dart';

class MyStar extends StatelessWidget{
  int number;

  MyStar({required this.number});

  @override
  Widget build(BuildContext context){
    return Container(
      child: Image.asset('lib/images/star'+number.toString()+'.png')
    );
  }
}