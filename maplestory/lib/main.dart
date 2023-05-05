import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/bar.dart';
import 'util/boy.dart';
import 'util/button.dart';
import 'util/cash.dart';
import 'util/snail.dart';
import 'util/star.dart';
import 'util/teddy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
  .then((_){
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();

}
class _MyHomePageState extends State<MyHomePage>{
  // BLUE SNAIL
  int snailSpriteCount = 1;
  static double snailPosX = 0.5;
  static double snailPosY = 1;
  String snailDirection = 'left';
  int deadSnailSprite = 0;
  bool snailAttacked = false;

  //TEDDY BEAR
  int teddySpriteCount = 1;
  double teddyPosX = 0.5;
  String teddyDirection = 'right';

  //BOY CHARACTER
  int boySpriteCount = 1;
  double boyPosX = 0.5;
  double boyPosY = 1;
  String boyDirection = 'right';
  int attackBoySpriteCount = 0;
  bool currentlySmiling = false;
  bool isJumping = false;
  bool isAttacking = false;

  // Loading Screen
  var loadingScreenColor = Colors.blue[100];
  var loadingScreenTextColor = Colors.blue[700];
  var tapToPlayColor = Colors.white;
  int loadingTime = 3;
  bool gameHasStarted = false;

  //Cash
  double cashPosX = 0.5;
  double cashPosY = 1;
  int cashSpriteStep = 1;
  bool isFalling = false;

  //Health mana exp
  int currentExp = 80;
  int currentHp = 120;
  int currentMana = 100;
  double levelUpPosX = 5;
  double levelUpPosY = 5;

  bool underAttack = false;
  bool currentlyLeveling = false;

  //DAMAGE
  double damageY = 0.8;
  double damageX = snailPosX - 0.2;
  Color? hitColor = Colors.transparent;

  //Star
  double starX = 2;
  double starY = 2;
  int starSprite = 0;

  void playNow(){
    startGameTimer();
    moveSnail();
    moveTeddy();
    attack();
  }

  void restartGame(){
    snailSpriteCount = 1;
    snailPosX = 1.2;
    snailPosY = 1;
    snailDirection = 'left';
    deadSnailSprite = 0;
    snailAttacked = false;

    //TEDDY BEAR
    teddySpriteCount = 1;
    teddyPosX = 0.5;
    teddyDirection = 'right';

    //BOY CHARACTER
    boySpriteCount = 1;
    boyPosX = 0.5;
    boyPosY = 1;
    boyDirection = 'right';
    attackBoySpriteCount = 0;
    currentlySmiling = false;
    isJumping = false;
    isAttacking = false;

    //STATS
    currentExp = 80;
    currentHp = 120;
    currentMana = 100;
    levelUpPosX = 5;
    levelUpPosY = 5;
    underAttack = false;
    currentlyLeveling = false;

    //DAMAGE
    damageY = 0.8;
    damageX = snailPosX - 0.2;
    hitColor = Colors.transparent;

    //Star
    starX = 2;
    starY = 2;
    starSprite = 0;
  } 

  void smile(){
    int smileTime = 3;
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
      setState(() {
        currentlySmiling = true;
        smileTime--;
      });
      if(smileTime == 0)
      {
        setState(() {
          currentlySmiling = false;
        });
        timer.cancel();
      }
    });
  }

  void startGameTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) { 
      setState(() {
        loadingTime--;
      });
      if(loadingTime == 0)
      {
        setState(() {
          loadingScreenColor = Colors.transparent;
          loadingTime = 3;
          loadingScreenTextColor = Colors.transparent;
        });
        timer.cancel();
      }
    });
  }
  
  void throwStar(){
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
      setState(() {
        attackBoySpriteCount++;
      });
      if(attackBoySpriteCount == 5)
      {
        if(boyDirection == 'right' && boyPosX + 0.2 > snailPosX){
          print('hit');
        }else{
          print('missed');
        }
        attackBoySpriteCount = 0;
        timer.cancel();
        starFlies();
      }
    });
  }
  void starFlies(){
    setState(() {
      if(currentMana>99)
      {
        starX = boyPosX + 0.1;
        starY = 0.9;
        currentMana -= 100;
      }
    });
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        starX += 0.05;
        starSprite++;
    });
    if((starX - snailPosX).abs() < 0.1){
      timer.cancel();
      showDamage();
      starX = 2;
      killSnail();
    }
    });
  }

  void jump(){
    if(!isJumping)
    {
      isJumping = true;
      double time = 0;
      double height = 0;
      double initialHeight = boyPosY;
      Timer.periodic(Duration(milliseconds: 70), (timer) { 
        time += 0.05;
        height = -4.9 * time * time + 2.5 * time;

        setState(() {
          if(initialHeight - height > 1 ){
            boyPosY = 1;
            timer.cancel();
            isJumping = false;
            boySpriteCount = 1;
          }else{
            boyPosY = initialHeight - height;
            boySpriteCount = 2;
          }
      });
    });
    }
    
  }

  void moveCash(){
    Timer.periodic(Duration(milliseconds: 300), (timer) { 
      setState(() {
        cashSpriteStep++;        
      });
      if((boyPosX - cashPosX.abs()<0.1)){
        collectItem();
        timer.cancel();
      }
    });
  }

  void collectItem(){
   setState(() {
          cashPosY = -2;
          cashPosX = 100;
      });
  }

  void showDamage(){
    damageX = snailPosX - 0.1;
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
      setState(() {
        damageY -= 0.01;
        hitColor = Colors.red[400];
      });
      if(damageY < 0.7){
        timer.cancel();
        damageY = 0.8;
        setState(() {
          hitColor = Colors.transparent;
          snailAttacked = false;
        });
      }
    });
  }

  void showLevelUp(){
    currentlyLeveling = true;
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
      setState(() {
        levelUpPosY -= 0.01;
      });
      if(levelUpPosY < 0.6){
        timer.cancel();
        currentlyLeveling = false;
        setState(() {
          levelUpPosY = 5;
          currentExp = 10;
          currentHp = 195;
          currentMana = 195;
        });
      }
    });
  }

  void addExp(){
    setState(() {
      if(currentExp + 80 > 200){
        currentExp = 190;
        levelUpPosX = boyPosX;
        levelUpPosY = boyPosY - 0.2;
        showLevelUp();
      }else{
        currentExp += 80;
      }
    });
  }

  void killSnail(){
    addExp();
    releaseItem();
    Timer.periodic(Duration(milliseconds: 200), (timer) { 
      setState(() {
        deadSnailSprite++;
      });
      if(deadSnailSprite == 5){
        deadSnailSprite = 0;
        timer.cancel();
        setState(() {
          snailPosX = 1.2;
          snailDirection = 'right';
          snailSpriteCount = 0;
        });
        moveSnail();
      }
    });
  }

  void releaseItem() {
    setState(() {
      cashPosX = snailPosX;
    });
    moveCash();
    
    double time = 0;
    double height = 0;
    double initialHeight = snailPosY;
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
      time += 0.05;
      height = -4.9 * time * time + 2.5 * time;

      setState(() {
        if(initialHeight - height > 1){
          cashPosY = 1;
          timer.cancel();
        } else {
          cashPosY = initialHeight - height;
        }
      });
    });

  }

  void attack(){
    if(!isAttacking)
    {
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
          setState(() {
            isAttacking = true;
            attackBoySpriteCount++;
          });

          if(attackBoySpriteCount == 5)
          {
            if(boyDirection == 'right' && boyPosX + 0.2 > snailPosX)
            {
              print('hit');
              showDamage();
              killSnail();
            } else{
              print('missed');
            }

            attackBoySpriteCount = 0;
            isAttacking = false;
            timer.cancel();
          }
    });
    }
    
  }

  void moveTeddy(){
    Timer.periodic(Duration(milliseconds: 100), (timer) { 
      setState(() {
        teddySpriteCount++;

        if(teddySpriteCount == 11)
        {
          teddySpriteCount = 1;
        }

        if((teddyPosX - boyPosX).abs() > 0.2){
          if (boyDirection == 'right'){
            teddyPosX = boyPosX - 0.2;
            teddyDirection = 'right';
          } else if (boyDirection == 'left'){
            teddyPosX = boyPosX + 0.2;
            teddyDirection = 'left';  
          }
        }
      });
    });
  }

  void moveSnail(){
    Timer.periodic(Duration(milliseconds: 150), (timer) { 
      setState(() {
        snailSpriteCount++;

        if (snailDirection == 'left'){
          snailPosX -= 0.01;
        } else{
          snailPosX += 0.01;
        }

        if(snailPosX < 0.3){
          snailDirection = 'right';
        } else if(snailPosX > 0.6){
          snailDirection = 'left';
        }

        if(snailSpriteCount == 5)
        {
          snailSpriteCount = 1;
        }

        if(deadSnailSprite != 0){
          timer.cancel();
        }

        if((snailPosX - boyPosX).abs() < 0.05){
          setState(() {
            boyPosX -= 0.15;
            currentHp -= 20;
            underAttack = true;
            if(currentHp<=0)
            {
              restartGame();
            }
          });
        } else {
          setState(() {
            underAttack = false;
          });
        }
      });
    });
  }

  void moveLeft(){
    setState(() {
      boyPosX -= 0.03;
      boySpriteCount++;
      boyDirection = 'left';
    });
  }

  void moveRight(){
    setState(() {
      boyPosX += 0.03;
      boySpriteCount++;
      boyDirection = 'right';
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (gameHasStarted == false){
                  playNow();
                  tapToPlayColor = Colors.transparent;
                  gameHasStarted = true;
                }
              },
              child: Container(
                color: Colors.blue[300],
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment(snailPosX, 1),
                      child: BlueSnail(
                        snailSpriteCount: snailSpriteCount,
                        snailDirection: snailDirection,
                        deadSnailSprite: deadSnailSprite,
                      ),
                    ),
                    Container(
                      alignment: Alignment(teddyPosX,1),
                      child: MyTeddy(
                        teddyDirection: teddyDirection,
                        teddySpriteCount: teddySpriteCount,
                      ),
                    ),
                    Container(
                      alignment: Alignment(boyPosX, boyPosY),
                      child: MyBoy(
                        boyDirection: boyDirection,
                        boySpriteCount: boySpriteCount % 2 + 1,
                        attackBoySpriteCount: attackBoySpriteCount,
                        currentlyLeveling: currentlyLeveling,
                        underAttack: underAttack,
                        smile: currentlySmiling,
                      ),
                    ),
                    Container(
                      alignment: Alignment(cashPosX,cashPosY),
                      child: MyCash(
                        cashSpriteStep: cashSpriteStep,
                      ),
                    ),
                    Container(
                      alignment: Alignment(starX, starY),
                      child: MyStar(
                        number: starSprite % 2 + 1 ,
                      ),
                    ),
                    Container(
                      alignment: Alignment(damageX, damageY),
                      child: Text(
                        '5',
                        style: TextStyle(
                          color: hitColor,
                          fontSize: 60,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment(levelUpPosX,levelUpPosY),
                      child: Text(
                        'LEVEL UP',
                        style: TextStyle(
                          color: Colors.yellow[300],
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      color: loadingScreenColor,
                      child: Center(
                        child: Text(
                          loadingTime.toString(),
                          style: TextStyle(
                            color: loadingScreenTextColor,
                            fontSize: 70,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment(0, -0.7),
                      child: Text(
                        'F L U T T E R ♥ M A P L E S T O R Y',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment(0, 0.4),
                      child: Text(
                        'T A P   T O   P L A Y',
                        style: TextStyle(
                          color: tapToPlayColor,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 10,
            color: Colors.green[700],
          ),
          Expanded(
            child: Container(
              color: Colors.grey[500],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyBar(
                          number: currentHp,
                          color: Colors.red,
                          child: Text(
                            '  H E A L T H ',
                            style:  TextStyle(color: Colors.red[100]),
                          ),
                        ),
                        MyBar(
                          number: currentMana,
                          color: Colors.blue,
                          child: Text(
                            '  M A N A ',
                            style:  TextStyle(color: Colors.blue[100]),
                          ),
                        ),
                        MyBar(
                          number: currentExp,
                          color: Colors.yellow,
                          child: Text(
                            '  E X P ',
                            style:  TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        text: ':)',
                        function: smile,
                      ),
                      MyButton(
                        text: 'ATTACK',
                        function: attack,
                      ),
                      MyButton(
                        text: 'x',
                        function: throwStar,
                      ),
                      MyButton(
                        text: '←',
                        function: (){
                          moveLeft();
                        },
                      ),
                      MyButton(
                        text: '↑',
                        function: (){
                          jump();
                        },
                      ),
                      MyButton(
                        text: '→',
                        function: (){
                          moveRight();
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }
}