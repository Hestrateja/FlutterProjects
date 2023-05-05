import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/blank_pixel.dart';
import 'package:snake/food_pixel.dart';
import 'package:snake/highscore_tile.dart';
import 'package:snake/poison_pixel.dart';
import 'package:snake/snake_pixel.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}):super(key:key);

  @override
  State<HomePage>createState()=>_HomePageState();
}

enum snake_Direction{UP,DOWN,LEFT,RIGHT}

class _HomePageState extends State<HomePage>{
  //grid dimensions
  int rowSize=20;
  int totalNumberOfSquares=400;

  bool gameHasStarted = false;
  bool gameOverBool = false;

  final _nameController = TextEditingController();

  //user score
  int currentScore = 0;

  //snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];
  //snake start to the right
  var currentDirection = snake_Direction.RIGHT;
  //food position
  int foodPos=55;
  int poisonPos=22;

  List<String> highscore_DocIds = [];
  late final Future? letsGetDocIds;

  @override
  void initState(){
    letsGetDocIds = getDocId();
    super.initState();
  }

  Future getDocId() async{
    await FirebaseFirestore.instance
    .collection("highscores")
    .orderBy("score",descending: true)
    .limit(10)
    .get()
    .then((value) => value.docs.forEach((element){
        highscore_DocIds.add(element.reference.id);
    }));
  }

  void startGame(){
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds:200), (timer) { 
      setState(() {
        moveSnake();
        
        if(gameOver()||gameOverBool){
          timer.cancel();
          if(currentScore<1)
            newGame();
          else{
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Your score is: '+currentScore.toString()),
                      TextField(
                        controller:  _nameController,
                        decoration: InputDecoration(hintText: 'Enter name'),
                      ),
                    ],
                  ),

                  actions: [
                    MaterialButton(
                      onPressed: (){
                        Navigator.pop(context);
                        submitScore();
                        newGame();
                      },
                      child: Text('Submit'),
                      color: Colors.pink
                    )
                  ],
                );
            //display a message to the user
            });
          }
          
        }
      });
    });
  }

  void submitScore(){
    //get access to the collection
    var database = FirebaseFirestore.instance;
    database.collection('highscores').add({
      "name": _nameController.text,
      "score": currentScore,
    });
  }

  void newGame() async{
    highscore_DocIds=[];
    await getDocId();
    setState(() {
      snakePos = [
        0,
        1,
        2
      ];
      foodPos == 55;
      poisonPos == 22;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
      gameOverBool = false;
    });
  }

  void eatFood(){
    //making sure the food is not where the snake is
    while(snakePos.contains(foodPos))
    {
      currentScore++;
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void eatPoison(){
    //making sure the food is not where the snake is
    while(snakePos.contains(poisonPos))
    {
      if(currentScore==0)
        gameOverBool = true;
      currentScore--;
      snakePos.removeAt(0);
      snakePos.removeAt(0);
      poisonPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake(){
    switch (currentDirection){
      case snake_Direction.RIGHT:{
        //add a new head
        //if snake is at the right wall
        if(snakePos.last%rowSize==19){
          gameOverBool=true;
        }else{
          snakePos.add(snakePos.last+1);
        }

      }break;
      case snake_Direction.LEFT:{
        //add a new head
        //if snake is at the left wall
        if(snakePos.last%rowSize==0){
          gameOverBool=true;
        }else{
          snakePos.add(snakePos.last-1);
        }

      }break;
      case snake_Direction.UP:{
        //add a new head
        //if snake is at the left wall
        if(snakePos.last<rowSize){
          gameOverBool=true;
        }else{
          snakePos.add(snakePos.last - rowSize);
        }

        //remove the tail
      }break;
      case snake_Direction.DOWN:{
        //add a new head
        //if snake is at the left wall
        if(snakePos.last+rowSize>totalNumberOfSquares){
          gameOverBool=true;
        }else{
          snakePos.add(snakePos.last + rowSize);
        }

      }break;

      default:
    }

    if(snakePos.last==foodPos){
      eatFood();
    }else if(snakePos.last==poisonPos){
      eatPoison();
    }else{
      //remove tail
      snakePos.removeAt(0);
    }
  }

  //game over
  bool gameOver(){
    //the game is over when the snake run into itself
    //this ocurrs when there is a duplicate position in the snake position list

    //this list is the body of the snake(no head)
    List<int> bodySnake = snakePos.sublist(0,snakePos.length-1);

    if(bodySnake.contains(snakePos.last)){
      return true;
    }

    return false;
  }
  @override
  Widget build (BuildContext context){

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)
          && currentDirection!=snake_Direction.UP){
            currentDirection=snake_Direction.DOWN;
          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)
          && currentDirection!=snake_Direction.DOWN){
            currentDirection=snake_Direction.UP;
          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)
          && currentDirection!=snake_Direction.RIGHT){
            currentDirection=snake_Direction.LEFT;
          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)
          && currentDirection!=snake_Direction.LEFT){
            currentDirection=snake_Direction.RIGHT;
          }
        },
        child: SizedBox(
          width: screenWidth>400 ? 400 : screenWidth,
          child: Column(
            children: [
              //score
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //user current score
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Current Score',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            currentScore.toString(),
                            style: TextStyle(fontSize:36, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    //highscore
                    Expanded(
                      child: gameHasStarted 
                      ? Container() :
                      FutureBuilder(
                        future: letsGetDocIds,
                        builder: (context, snapshot){
                          return ListView.builder(
                            itemCount: highscore_DocIds.length,
                            itemBuilder: ((context, index){
                              return HighScoreTile(documentId: highscore_DocIds[index]);
                            }),
                          );
                        })
                      ),
                  ],
      
                ),
              ),
      
              //grid
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if(details.delta.dy>0
                    && currentDirection!=snake_Direction.UP){
                      //down
                      currentDirection = snake_Direction.DOWN;
                    }else if(details.delta.dy<0
                    && currentDirection!=snake_Direction.DOWN)
                    {
                      //up
                      currentDirection = snake_Direction.UP;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if(details.delta.dx>0
                    && currentDirection!=snake_Direction.LEFT){
                      //right
                      currentDirection = snake_Direction.RIGHT;
                    }else if(details.delta.dx<0
                    && currentDirection!=snake_Direction.RIGHT)
                    {
                      //left
                      currentDirection = snake_Direction.LEFT;
                    }
                  },
                  child: GridView.builder(
                    itemCount: totalNumberOfSquares,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize
                    ),
                    itemBuilder: (context,index){
                      if(snakePos.contains(index)){
                        return const SnakePixel();  
                      }else if(foodPos == index){
                        return const FoodPixel();  
                      }else if(poisonPos == index){
                        return const PoisonPixel();  
                      }else{
                        return const BlankPixel();
                      }
                        
                    },
                  ),
                ),
              ),
      
              //play button
              Expanded(
                child: Container(
                    child: Center(
                      child: MaterialButton(
                        child: Text('Play'),
                        color: Colors.pink,
                        onPressed: gameHasStarted?(){}:startGame,
                      ),
                    ),
                ),
              )
      
            ],
          ),
        ),
      )
    );
  }
}