import 'package:flutter/material.dart';

import 'homepage.dart';
import 'package:firebase_core/firebase_core.dart';

Future main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBQ_m7VWd9Ae-rlJuBEmxC30tIocU0BMdI",
        authDomain: "snake-a0934.firebaseapp.com",
        projectId: "snake-a0934",
        storageBucket: "snake-a0934.appspot.com",
        messagingSenderId: "626644523844",
        appId: "1:626644523844:web:370c15e2012b31cdd11511",
        measurementId: "G-SKL1YGJGXM"
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}