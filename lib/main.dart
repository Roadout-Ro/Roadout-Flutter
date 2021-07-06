import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roadout/welcome.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Roadout',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}