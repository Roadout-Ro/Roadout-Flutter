import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roadout/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser?.uid != null) {
    runApp(MainApp());
  } else {
    runApp(WelcomeApp());
  }
}

class WelcomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roadout',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roadout',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}