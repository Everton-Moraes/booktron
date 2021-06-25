import 'package:booktron/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//DESENVOLVIDO POR
// ANTONIO EDUARDO
// EVERTON MORAES
// RENATO JOSE

void main() {
  runApp(BookTron());
  Firebase.initializeApp();
}

class BookTron extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookTron',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
