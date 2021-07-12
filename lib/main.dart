import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roadout/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:roadout/utilites.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roadout',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}