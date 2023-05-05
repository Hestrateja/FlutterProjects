import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'pixel.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int numberOfSquares = 160;
  List<int> piece = [];
  var direction = "left";
  List<int> landed = [100000];
  int level = 0;

  void startGame(){
    if(level==0&&piece.length!=0)
      return;
    level = 0;
    landed = [100000];
    piece = [
      numberOfSquares - 5 - level * 10,
      numberOfSquares - 4 - level * 10,
      numberOfSquares - 3 - level * 10,
      numberOfSquares - 2 - level * 10,
      numberOfSquares - 1 - level * 10,
    ];
    Timer.periodic(Duration(milliseconds:250), (timer) {
      if(checkWinner()){
        _showDialog();
        timer.cancel();
      }
      if(isGameOver()){
        gameOver();
        timer.cancel();
      }

      if(piece.first % 10 == 0){
        direction = "right";
      }else if(piece.last% 10 == 9){
        direction = "left";
      }

      setState((){
        if(direction == "right"){
          for(int i = 0; i<piece.length;i++){
            piece[i] += 1;
          }
        } else{
          for(int i = 0; i< piece.length; i++){
            piece[i] -=1;
          }
        }
      });
    });
  }

  bool checkWinner(){
    if(landed.last<10){
      return true;
    } else{
      return false;
    }
  }
  bool isGameOver(){
    int counter = 0;
    if(level==0)
      return false;
    for(int i = 159; i>159-10*level; i--){
      if(landed.contains(i)){
        counter = 0;
      }else{
        counter++;
        if(counter==10)
        {
          return true;
        }

      }
    }
    return false;
  }

  void _showDialog(){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Winner!"),
      );
    });
  }
  void gameOver(){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Game Over!"),
      );
    });
  }

  void stack(){
    setState((){
      level++;
      for(int i = 0; i<piece.length;i++){
        landed.add(piece[i]);
      }

      if(level<5){
        piece = [
          numberOfSquares - 5 - level * 10,
          numberOfSquares - 4 - level * 10,
          numberOfSquares - 3 - level * 10,
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10,
        ];
      } else if(level >= 5 && level <9){
        piece = [
          numberOfSquares - 4 - level * 10,
          numberOfSquares - 3 - level * 10,
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10,
        ];
      }else if(level >= 9 && level <14){
        piece = [
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10,
        ];
      } else if (level >= 14){
        piece = [numberOfSquares - 1 - level*10];
      }

      checkStack();
    });
  }

  void checkStack(){
    for(int l = 0; l<max(piece.length,2);l++)
    {
      for(int i = 0; i< landed.length; i++){
        if(!landed.contains(landed[i] + 10)&&
        (landed[i] + 10) <= numberOfSquares -1){
          landed.remove(landed[i]);
        }
      }
    }
    
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GridView.builder(
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10),
              itemBuilder: (BuildContext context, int index){
                if(piece.contains(index)){
                  return MyPixel(
                    color: Color.fromARGB(255, 143, 213, 146),
                  );
                } else if (landed.contains(index)){
                  return MyPixel(
                    color: Color.fromARGB(255, 143, 213, 146), 
                  );
                } else{
                  return MyPixel(
                    color: Color.fromARGB(255, 46, 46, 46),
                  );   
                }
              },
            )
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    function: startGame,
                    child: Text(
                      "P L A Y",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  MyButton(
                    function: stack,
                    child: Text(
                      "S T O P",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}