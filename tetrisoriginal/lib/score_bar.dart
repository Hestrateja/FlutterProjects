import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ScoreBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScoreBarState();
}

class _ScoreBarState extends State {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 82, 82, 82), Color.fromARGB(255, 64, 64, 64)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Score: ${Provider.of<Data>(context,listen:true).score}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 204, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}