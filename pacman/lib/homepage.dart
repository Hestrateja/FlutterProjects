import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/ghost2.dart';
import 'package:pacman/ghost3.dart';
import 'package:pacman/pacman.dart';

import 'barriers.dart';
import 'ghost.dart';
import 'pixel.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  static int numberOfSquares = numberInRow * 17;
  static int numberInRow = 11;
  int player = 166;
  int ghost = 20;
  int ghost2 = 12;
  int ghost3 = 174;
  bool mouthClosed = true;
  int score = 0;

  static List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    24,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    30,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    57,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    39,
    28,
    17,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
    158,
    160    
  ];
  List<int> food = [];

  void getFood(){
    for(int i = 0; i<numberOfSquares;i++)
    {
      if(!barriers.contains(i))
      {
        food.add(i);
      }
    }
  }
  
  String direction = "right";
  bool gameStarted = false;

  void startGame(){
    print(MediaQuery.of(context).size.width);
    moveGhost();
    moveGhost2();
    moveGhost3();
    gameStarted = true;
    getFood();
    Duration duration = Duration(milliseconds: 120);
    Timer.periodic(duration, (timer) { 
      if(food.contains(player)){
        food.remove(player);
      }

      switch(direction){
        case "right":
          moveRight();
          break;
          case "up":
          moveUp();
          break;
          case "left":
          moveLeft();
          break;
          case "down":
          moveDown();
          break;

      }
    });
  }

  String ghostDirection = "left";
  void moveGhost(){
    Duration ghostSpeed = Duration(milliseconds: 500);
    Timer.periodic(ghostSpeed, (timer) { 
      if(!barriers.contains(ghost-1)&& ghostDirection != "right"){
        ghostDirection = "left";
      }else if(!barriers.contains(ghost-numberInRow)&& ghostDirection != "down"){
        ghostDirection = "up";
      }else if(!barriers.contains(ghost+numberInRow)&& ghostDirection != "up"){
        ghostDirection = "down";
      }else if(!barriers.contains(ghost+1)&& ghostDirection != "left"){
        ghostDirection = "right";
      }

      switch(ghostDirection){
        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost-=numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost+=numberInRow;
          });
          break;          
          
      }
    });
  }

  String ghostDirection2 = "left";
  void moveGhost2(){
    Duration ghostSpeed2 = Duration(milliseconds: 700);
    Timer.periodic(ghostSpeed2, (timer) { 
      if(!barriers.contains(ghost2-1)&& ghostDirection2 != "right"){
        ghostDirection2 = "left";
      }else if(!barriers.contains(ghost2-numberInRow)&& ghostDirection2 != "down"){
        ghostDirection2 = "up";
      }else if(!barriers.contains(ghost2+numberInRow)&& ghostDirection2 != "up"){
        ghostDirection2 = "down";
      }else if(!barriers.contains(ghost2+1)&& ghostDirection2 != "left"){
        ghostDirection2 = "right";
      }

      switch(ghostDirection2){
        case "right":
          setState(() {
            ghost2++;
          });
          break;

        case "up":
          setState(() {
            ghost2-=numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost2--;
          });
          break;

        case "down":
          setState(() {
            ghost2+=numberInRow;
          });
          break;          
          
      }
    });
  }

  String ghostDirection3 = "left";
  void moveGhost3(){
    Duration ghostSpeed3 = Duration(milliseconds: 200);
    Timer.periodic(ghostSpeed3, (timer) { 
      if(!barriers.contains(ghost3-1)&& ghostDirection3 != "right"){
        ghostDirection3 = "left";
      }else if(!barriers.contains(ghost3-numberInRow)&& ghostDirection3 != "down"){
        ghostDirection3 = "up";
      }else if(!barriers.contains(ghost3+numberInRow)&& ghostDirection3 != "up"){
        ghostDirection3 = "down";
      }else if(!barriers.contains(ghost3+1)&& ghostDirection3 != "left"){
        ghostDirection3 = "right";
      }

      switch(ghostDirection3){
        case "right":
          setState(() {
            ghost3++;
          });
          break;

        case "up":
          setState(() {
            ghost3-=numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost3--;
          });
          break;

        case "down":
          setState(() {
            ghost3+=numberInRow;
          });
          break;          
          
      }
    });
  }

  void moveRight(){
    setState(() {
      if(!barriers.contains(player+1))
      {
        player +=1;
      }
    });
  }
  void moveUp(){
    setState(() {
      if(!barriers.contains(player-numberInRow))
      {
        player -=numberInRow;
      }
    });
  }
  void moveDown(){
    setState(() {
      if(!barriers.contains(player+numberInRow))
      {
        player +=numberInRow;
      }
    });
  }
  void moveLeft(){
    setState(() {
      if(!barriers.contains(player-1))
      {
        player -=1;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            children: [
              Container(
                height: 35,
                child: GestureDetector(
                  onTap: startGame,
                  child: Text(
                    "P L A Y",
                    style: TextStyle(color: Colors.grey[300], fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    child: GestureDetector(
                      onVerticalDragUpdate: (details){
                        if(details.delta.dy>0){
                          direction = "down";
                        }else if(details.delta.dy < 0)
                        {
                          direction = "up";
                        }
                      },
                      onHorizontalDragUpdate: (details) {
                        if(details.delta.dx>0)
                        {
                          direction = "right";
                        }else if(details.delta.dx<0)
                        {
                          direction = "left";
                        }
                      },
                      child: Container(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: numberOfSquares,
                          gridDelegate: 
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:  numberInRow),
                          itemBuilder: (BuildContext context, int index){
                            if(player == index){
                              if(!mouthClosed){
                                return Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                );
                              } else{
                                if(direction=="right"){
                                  return PacmanDude();
                                }else if(direction=="up"){
                                  return Transform.rotate(
                                    angle: 3 * pi / 2, child: PacmanDude());
                                }else if(direction=="left"){
                                  return Transform.rotate(
                                    angle: pi, child: PacmanDude());
                                }else if(direction=="down"){
                                  return Transform.rotate(
                                    angle: pi / 2, child: PacmanDude());
                                }
                              }
                            } else if(ghost == index){
                              return Ghost();
                            } else if(ghost2 == index){
                              return Ghost2();
                            }else if(ghost3 == index){
                              return Ghost3();
                            }else if(barriers.contains(index)){
                              return MyBarrier(
                                innerColor: Colors.blue[800],
                                outerColor: Colors.blue[900],
                              );
                            } else if(food.contains(index) || !gameStarted){
                              return MyPixel(
                                innerColor: Colors.yellow,
                                outerColor: Colors.black,
                              );
                            } else{
                              return MyPixel(
                                innerColor: Colors.black,
                                outerColor: Colors.black,
                              );
                            }
                            return SizedBox();
                          },)
                      )
                    )
                  ),
                ),
              )
            ],
          )
        )
      )
    );
  }


}