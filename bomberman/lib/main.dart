import 'package:flutter/material.dart';

import 'homepage.dart';

 main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}