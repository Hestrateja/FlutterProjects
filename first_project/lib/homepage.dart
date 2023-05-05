import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_project/bola.dart';
import 'package:first_project/boton.dart';
import 'package:first_project/misil.dart';
import 'package:first_project/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum direcciones{IZQ,DER}

class _HomePageState extends State<HomePage> {

  //variables del jugador:
  static double playerX=0;

  //varibles del misil
  double misilX=playerX;
  double alturaMisil =10;
  bool duranteDisparo = false;

  double speed = 0.025;

  //variables de bola
  double bolaX=0.5;
  double bolaY=1;
  int diameter = 40;
  var direccionBola= direcciones.IZQ;

  void startGame(){
    
    double tiempo =0;
    double altura = 0;
    double velocidad=50; //fuerza de salto
   
    Timer.periodic(Duration(milliseconds: 20), (timer){
      //ecuacion cuadratica que modela el rebote
      altura=-5*tiempo*tiempo+velocidad*tiempo;

      if(altura<0){
        tiempo=0;
      }

      setState(() {
       bolaY= alturaAPosicion(altura);
      });


        //si la bola llega a la pared izquierda cambie de direccion a derecha
        if(bolaX-0.01<-1){
          direccionBola= direcciones.DER;
         //si la bola llega a la pared derecha cambie de direccion a izquierda  
        }else if(bolaX+0.01>1){
          direccionBola= direcciones.IZQ;
        }
        //mover la bola en la direccion correcta
        if(direccionBola== direcciones.IZQ){
               setState(() {
            bolaX-=0.01;
            });
        }else if(direccionBola== direcciones.DER){
             setState(() {
            bolaX+=0.01;
           });
        }

        //revisar si la bola golpea al jugador
        if(jugadorMuere()){
          timer.cancel();
          _mostrarDialogo();
        }
       
       tiempo +=0.1;
    });
  }

void _mostrarDialogo(){
  showDialog(
    context: context,
    builder:(BuildContext context){
    return AlertDialog(
      backgroundColor: Colors.grey[700],
      title: Center(
          child: Text(
          "Vuelve a intentarlo",
          style: TextStyle(color: Colors.white),
       )),
      );
  });
}

  void moverIzq(){
    setState(() {
     
      if(playerX-speed<-1-speed%1){
        //hacer nada
      }else{
       playerX= playerX-speed;
      }

      //solo tome la coordenada x del jugador cuando no esta durante disparo
      if(duranteDisparo==false){
        misilX= playerX;  
      }
    });
  }

  void moverDer(){
    setState(() {
     
      if(playerX+speed>1+speed%1){
        //hacer nada
      }else{
       playerX+=speed;
      }
       //solo tome la coordenada x del jugador cuando no esta durante disparo
      if(duranteDisparo==false){
        misilX= playerX;  
      }
    });
  }

  void disparar(){
    if(duranteDisparo==false){
      Timer.periodic(Duration(milliseconds: 20),(timer) {
      //se disparo
      duranteDisparo=true;

      //el misil crece hasta que llega al tope de la pantalla
      setState(() {
        alturaMisil+=10;
      });

      //parar al misil si llega a la parte superior de la pantall
      if(alturaMisil>MediaQuery.of(context).size.height*3/4){
        //detener misil
        reiniciarMisil();
        timer.cancel();
      }

      //revisar si el misil choco con la bola
      if(bolaY>alturaAPosicion(alturaMisil)&&
        (bolaX-misilX).abs()<diameter*0.001 ){
        reiniciarMisil();
        bolaX=5;
        timer.cancel();
      }
    });
    }
  }

  //convertir altura a una coordenada
  double alturaAPosicion(double altura){
    double alturaTotal = MediaQuery.of(context).size.height*3/4;
    double posicion = 1-2*altura/alturaTotal;
    return posicion;
  }

  void reiniciarMisil(){
    misilX= playerX;
    alturaMisil=10;
     duranteDisparo=false;
  }
 
  bool jugadorMuere(){
    //si la posicion de la bola y el jugar son la mismas el jugador muere
    if((bolaX-playerX).abs()<0.05 && bolaY>0.95){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode:  FocusNode(),
      autofocus: true,
      onKey: (event){
        if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
          moverIzq();
        }else  if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
          moverDer();
        }
       
        if(event.isKeyPressed(LogicalKeyboardKey.space)){
          disparar();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex:3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                   MyBall(
                    ballX: bolaX,
                    ballY: bolaY,
                    diameter: diameter,
                    ),
                   MyMissile(
                    altura: alturaMisil,
                    missileX: misilX,
                   ),
                   MyPlayer(
                     playerX: playerX,
                   ),
                 
                  ],
                ),
              ),
             ),
            ),
            Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                MyButton(
                  icon: Icons.play_arrow,
                  function: startGame,
                ),  
                MyButton(
                  icon: Icons.arrow_back,
                  function: moverIzq,
                ),
                MyButton(
                  icon: Icons.arrow_upward,
                  function: disparar,
                ),
                MyButton(
                  icon: Icons.arrow_forward,
                  function: moverDer,
                ),
               ],
              ),
             ),
            ),
        ],
   
      ),
    );
  }
}